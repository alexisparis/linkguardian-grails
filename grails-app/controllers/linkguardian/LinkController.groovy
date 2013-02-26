package linkguardian

import grails.converters.JSON
import grails.gorm.DetachedCriteria
import grails.plugins.springsecurity.Secured
import grails.util.GrailsUtil
import grails.web.JSONBuilder
import groovy.json.JsonBuilder
import linkguardian.exception.TagException
import net.sf.json.JSONObject
import org.springframework.web.servlet.ModelAndView

import java.util.logging.Level

/**
 *
 * see http://viralpatel.net/blogs/first-play-framework-gae-siena-application-tutorial-example/
 */
@Secured(['ROLE_USER'])
class LinkController
{
    static defaultAction = "list"

    def linkBuilderService

    def springSecurityService

    def linksPerPage = 100

    def success(String msg)
    {
        return new linkguardian.Message(message : msg, level : linkguardian.Level.SUCCESS)
    }

    def error(String msg)
    {
        return new linkguardian.Message(message : msg, level : linkguardian.Level.ERROR)
    }

    def warning(String msg)
    {
        return new linkguardian.Message(message : msg, level : linkguardian.Level.WARNING)
    }

    def list()
    {
        log.info "username : " + springSecurityService.principal.username
        log.info "username class : " + springSecurityService.principal.class
        log.info "auth : " + springSecurityService.authentication?.name
        log.info "auth class : " + springSecurityService.authentication?.class
        log.info "current user : " + springSecurityService.currentUser
        log.info "current user class : " + springSecurityService.currentUser?.class


        <sec:loggedInUserInfo field="fullName"/>
    }

    /**
     * filter the links and returns them as JSON result
     * @param token
     * @param read_status : all, read or unread
     * @return
     */
    def filter(String token, String read_status, String sortBy, String sortType, int page)
    {
        def start = System.currentTimeMillis();
        log.info "calling filter from LinkController with filter equals to " + token + ", read status : " + read_status + ", sort by " + sortBy + " " + sortType + ", page = " + page

        def queryLinks = Collections.emptyList()

        def _sortBy = sortBy
        if ( _sortBy != "creationDate" && _sortBy != "note" )
        {
             _sortBy = "creationDate"
        }
        def _sortType = sortType
        if ( _sortType != "asc" && _sortType != "desc" )
        {
            _sortType = "asc"
        }

        def success = true

        def read = true
        def unread = true
        if ( read_status == 'read' )
        {
            unread = false
        }
        else if ( read_status == 'unread' )
        {
            read = false
        }

        if ( read || unread ) // no need to launch the request if ! read && ! unread
        {
            def queryParams = [max: linksPerPage, offset: (page - 1) * linksPerPage, sort: _sortBy, order: _sortType]

            def query = Link.where { person.username == springSecurityService.getPrincipal().username }

            def tokens = linkBuilderService.extractTags(token)

            log.info "tokens size : " + tokens.size()
            if ( tokens != null && tokens.size() > 0)
            {
                if ( tokens.size() == 1 )
                {
                    query = query.where {
                        tags {
                            label =~ tokens.first() + "%"
                        }
                    }
                }
                else
                {
                    response.status = 500
                    render this.error(message(code: "service.link.filter.oneTagAllowed")) as JSON
                    success = false
                }
            }

            if ( ! read )
            {
                query = query.where { read == false }
            }
            if ( ! unread )
            {
                query = query.where { read == true }
            }

            def query_start = System.currentTimeMillis();

            queryLinks = query.list(queryParams)

            log.info "query execution : " + (System.currentTimeMillis() - query_start) + " ms"
        }

        if ( success )
        {
            log.info "query links found count : " + queryLinks.size()

            def pageError = false

            if ( page > 0 ) // called from infinite scroll
            {
                if ( queryLinks.isEmpty() )
                {
                    response.status = 404
                    pageError = true
                }
            }

            if ( ! pageError )
            {
                render(contentType: "text/json") {
                    links = array{
                        for (a in queryLinks) {
                            item title: a.title,
                                 read: a.read,
                                 url : a.url,
                                 id: a.id,
                                 note: a.note.ordinal(),
                                 domain: a.domain,
                                 description: a.description,
                                 tags : array{
                                     for(b in a.tags) {
                                         subitem label : b.label
                                     }
                                 }
                        }
                    }
                }

                log.info "filter execution : " + (System.currentTimeMillis() - start) + " ms"
            }
        }
    }

    /**
     * add a new link
     * @return
     */
    def addUrl()
    {
        log.info "calling addUrl with url : " + params.url + " tags : " + params.tag + " and render : " + params.render

        def msg

        if ( params.url == null || params.url.trim().length() == 0 )
        {
            response.status = 500
                msg = this.error(message(code: "service.link.addUrl.invalidUrl"))
            }
            else
            {
            def realUrl = null

            // manage redirect url
            def urls = new HashSet<String>()
            def redirectLimitCount = 10
            def redirectCount = 0
            def currentUrl = params.url

            // if params.url does not contains ://, then add http://
            if ( currentUrl.indexOf("://") == -1 )
            {
                log.warn("adding http:// to url without protocol : " +currentUrl)
                currentUrl = "http://" + currentUrl
            }

            try  {
                while(redirectCount < redirectLimitCount && realUrl == null && currentUrl != null)  {
                   if ( urls.add(currentUrl) )
                   {
                       def _url = new URL(currentUrl)
                       def _connection = _url.openConnection()
                       if ( _connection instanceof HttpURLConnection )
                       {
                          def _httpConnection = (HttpURLConnection)_connection
                          def code = _httpConnection.getResponseCode()
                          if( code >= 300 && code < 400 ){ // redirection
                             currentUrl = null
                             def location = _httpConnection.getHeaderField("Location")
                             if ( location != null ){
                                 currentUrl = location
                             }
                          }
                          else{
                              realUrl = currentUrl
                          }
                       }
                   }
                   else
                   {
                       response.status = 500
                       msg = this.error(message(code: "service.link.addUrl.redirectionLoop"))
                       break
                   }

                   redirectCount++
                }

                if ( realUrl == null )
                {
                    if ( msg != null && redirectCount >= redirectLimitCount )
                    {
                        response.status = 500
                        msg = this.error(message(code: "service.link.addUrl.tooMuchRedirections"))
                    }
                }
            }
            catch(Exception e)
            {
                response.status = 500
                log.error("error while trying to resolve redirections", e)
            }

            if ( response.status == 500 && msg == null )
            {
                // if no error detected before
                // use url given by user to use default error handling
                realUrl = params.url
            }

            if ( realUrl != null )
            {
                def connectedPerson = Person.findByUsername(springSecurityService.getPrincipal().username)

                // desactivated since we use url shortener
                try {

                    def _tag = (params.tag == null ? "" : params.tag.toLowerCase())

                    def newLink = new Link(url: realUrl, fusionedTags: " " + _tag + " ", creationDate: new Date(), person: connectedPerson)

                    linkBuilderService.complete(newLink)
                    linkBuilderService.addTags(newLink, params.tag)

                    // check that this url does not already exist
                    if ( Link.findByPersonAndUrl(connectedPerson, newLink.url) != null )
                    {
                        def tata = message(code: "service.link.addUrl.linkAlreadyExists", args: [params.url])
                        log.info "################################################ params.url : " + params.url + " ==> " + tata
                        def toto = message(code: "service.link.addUrl.linkAlreadyExists", args: ['toto'])
                        log.info "################################################ params.url : " + 'toto' + " ==> " + toto
                        response.status = 500
                        msg = this.error(message(code: "service.link.addUrl.linkAlreadyExists", args: [params.url]))
                    }
                    else
                    {
                        newLink.save(flush: true)

                        msg = this.success(message(code: "service.link.addUrl.linkCreated"))
                    }
                }
                catch(TagException e)
                {
                    response.status = 500
                    msg = this.error( ((TagException)e).getMessage() )
                }
                catch(Exception e)
                {
                    log.error(e.getClass().name + " :: error while trying to save new link with url : " + params.url, e)
                    response.status = 500
                    if ( e.getCause() != null )
                    {
                        if ( e.getCause() instanceof MalformedURLException )
                        {
                            msg = this.error(message(code: "service.link.addUrl.invalidUrlWithCause", args: [params.url, e.getCause().getMessage()]))
                        }
                        else if ( e.getCause() instanceof UnknownHostException )
                        {
                            msg = this.error(message(code: "service.link.addUrl.unknownHost", args: [((UnknownHostException)e.getCause()).getMessage()]))
                        }
                    }

                    if ( msg == null )
                    {
                        // default message
                        msg = this.error(message(code: "service.link.addUrl.defaultError", args: [params.url]))
                    }
                }
            }
        }

        if ( params.render == 'json' )
        {
            render msg as JSON
        }
        else if ( params.render == 'html' )
        {
            //render(view: "/link/url-adding-attempt", model: msg)
            return new ModelAndView("/link/url-adding-attempt", [ res : msg ])
        }

    }

    /**
     * delete a link
     * @param id
     * @return
     */
    def delete(String id)
    {
        def success = false

        log.info "calling delete link with id : " + id;

        Link link = Link.get(id);
        if (link != null)
        {
            if ( link.person.username == springSecurityService.getPrincipal().username )
            {
                link.delete()
                success = true
            }
            else
            {
                response.status = 500
                msg = this.error(message(code: "service.link.delete.forbidden")) as JSON
            }
        }

        if (success)
        {
            render this.success(message(code: "service.link.delete.success")) as JSON
        }
        else
        {
            response.status = 500
            render this.error(message(code: "service.link.delete.error")) as JSON
        }
    }

    /**
     * add a new tag to an existing link
     * @param id
     * @param tag
     * @return
     */
    def addTag(String id, String tag)
    {
        log.info "calling addTag for link " + id + " with tag " + tag
        def msg
        def success = false

        Link link = Link.get(id)
        if (link != null && tag != null)
        {
            if ( link.person.username == springSecurityService.getPrincipal().username )
            {
                def tagsToAdd = linkBuilderService.extractTags(tag)

                int tagsToAddSize = tagsToAdd.size()
                def severallTagsToAdd = tagsToAddSize > 1
                log.info "tags to add count : " + tagsToAddSize
                tagsToAdd.each {
                    log.info "   " + it + "#"
                }

                if ( tagsToAddSize == 0 )
                {
                    response.status = 500
                    msg = this.error(message(code: "service.link.addTag.invalidTag"))
                }
                else
                {
                    // remove from the set tags that already exist
                    link.tags.each {
                        if ( tagsToAdd.contains(it.label) )
                        {
                            tagsToAdd.remove(it.label)
                        }
                    }

                    if ( tagsToAdd.isEmpty() )
                    {
                        response.status = 500
                        def i18nCode
                        if ( severallTagsToAdd )
                        {
                            i18nCode = "service.link.addTag.tagsExist"
                        }
                        else
                        {
                            i18nCode = "service.link.addTag.tagExists"
                        }

                        msg = this.error(message(code: i18nCode))
                    }
                    else
                    {
                        linkBuilderService.addTags(link, tagsToAdd.join(" "))

                        success = true
                        if ( severallTagsToAdd )
                        {
                            if ( tagsToAdd.size() < tagsToAddSize )
                            {
                                msg = this.warning(message(code: "service.link.addTag.someTagsAdded"))
                            }
                            else
                            {
                                msg = this.success(message(code: "service.link.addTag.tagsAdded"))
                            }
                        }
                        else
                        {
                            msg = this.success(message(code: "service.link.addTag.tagAdded"))
                        }
                    }
                }
            }
            else
            {
                response.status = 500
                msg = this.error(message(code: "service.link.addTag.forbidden"))
            }
        }
        else
        {
            response.setStatus(500)
            msg = this.error(message(code: "service.link.addTag.error"))
        }

        if ( success )
        {
            render(contentType: "text/json") {

                tags = array{
                    for (a in link.tags) {
                        item label: a.label
                    }
                }
                message = msg
            }
        }
        else
        {
            response.contentType = "text/json"
            render msg as JSON
        }
    }

    /**
     * delete a tag from a link
     * @param id
     * @param tag
     * @return
     */
    def deleteTag(String id, String tag)
    {
        log.info "calling deleteTag for link " + id + " for tag " + tag
        def success = false

        Link link = Link.get(id)
        if (link != null && tag != null)
        {
            if ( link.person.username == springSecurityService.getPrincipal().username )
            {
                def tagToDelete = null

                link.tags.each {
                    if ( tagToDelete == null && it.label == tag )
                    {
                        tagToDelete = it
                    }
                }

                if ( tagToDelete == null )
                {
                    response.status = 500
                    render this.error(message(code: "service.link.deleteTag.tagDoesNotExist"), args: [tag]) as JSON
                }
                else
                {
                    link.removeFromTags(tagToDelete)
                    link.save(flush:  true)
                    success = true
                }
            }
            else
            {
                response.status = 500
                render this.error(message(code: "service.link.deleteTag.forbidden")) as JSON
            }
        }

        if (success)
        {
            render this.success(message(code: "service.link.deleteTag.success"), args: [tag]) as JSON
        }
        else
        {
            response.status = 500
            render this.error(message(code: "service.link.deleteTag.error")) as JSON
        }
    }

    /**
     * update the note of the link
     * @param id the id of the link
     * @param oldScore
     * @param newScore
     * @return
     */
    def updateNote(String id, Integer oldScore, Integer newScore)
    {
        println "calling update note from " + oldScore + " to " + newScore

        def link = Link.get(id);

        def success = false
        def msg = null

        if (link == null)
        {
            response.status = 500
            msg = this.error("link not found")
        }
        else
        {
            if ( link.person.username == springSecurityService.getPrincipal().username )
            {
                try
                {   def _score = newScore
                    if (_score == null)
                    {
                        _score = 0
                    }

                    _score = Math.max(0, Math.min(_score, 5))

                    link.note = Note.valueOf(Note.class, "Note_" + _score)
                    link.save()
                    msg = this.success(message(code: "service.link.updateNote.success"))
                    success = true
                }
                catch (Exception e)
                {
                    log.error("error while trying to update the note", e)
                }
            }
            else
            {
                response.status = 500
                msg =  this.error(message(code: "service.link.updateNote.forbidden"))
            }
        }

        if (! success && msg == null)
        {
            response.status = 500
            msg = this.error(message(code: "service.link.updateNote.error"))
        }

        render msg as JSON
    }

    /**
     * mark a link as read
     * @param id
     */
    def markAsRead(String id)
    {
        changeReadAttribute(id, true)
    }

    /**
     * mark a link as unread
     * @param id
     */
    def markAsUnread(String id)
    {
        changeReadAttribute(id, false)
    }

    /**
     * change the read attribute of a link
     * @param id
     * @param value
     */
    def changeReadAttribute(String id, boolean value)
    {
        log.info "calling changeReadAttribute for link : " + id + " read : " +value

        def success = false
        def msg = null
        def link = Link.get(id)

        String readType
        if ( value )
        {
            readType = message(code: "link.read.label")
        }
        else
        {
            readType = message(code: "link.unread.label")
        }

        if ( link != null )
        {
            if ( link.person.username == springSecurityService.getPrincipal().username )
            {
                link.read = value
                link.save()
                msg = this.success(message(code: "service.link.changeReadAttribute.success", args: [readType]))
                success = true
            }
            else
            {
                msg =  this.error(message(code: "service.link.changeReadAttribute.forbidden"))
            }
        }
        if ( ! success && msg == null )
        {
            response.status = 500
            msg = this.error(message(code: "service.link.changeReadAttribute.error", args: [readType]))
        }

        render msg as JSON
    }

    /**
     *
     */
    def getTagsCloud()
    {
        log.info "calling getTagsCloud"

        def results = new ArrayList()

        def iterator

        def q = Tag.createCriteria()
        iterator = q.list {
            links {
                person
                {
                    eq('username', springSecurityService.getPrincipal().username)
                }
            }
            projections{
                groupProperty('label')
                rowCount('total') //alias given to count
            }
        }

        iterator.each {
            log.info "consider tag : " + it[0] + " with an occurrence of " + it[1]
            results.add(new TagWeight(tag: it[0], weight: it[1]))
        }

        render results as JSON
    }
}
