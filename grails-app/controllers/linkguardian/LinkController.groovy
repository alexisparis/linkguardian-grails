package linkguardian

import grails.converters.JSON
import grails.gorm.DetachedCriteria
import grails.plugins.springsecurity.Secured
import linkguardian.exception.TagException
import linkguardian.link.TargetDeterminationError
import org.springframework.web.servlet.ModelAndView

/**
 *
 * see http://viralpatel.net/blogs/first-play-framework-gae-siena-application-tutorial-example/
 */
@Secured(['ROLE_USER'])
class LinkController extends MessageOrientedObject
{
    static defaultAction = "list"

    def linkBuilderService

    def springSecurityService

    def linksPerPage = 100

    def shortenerService

    def formatUrl(String url)
    {
        def result = url
        if ( url )
        {
            if( url.length() > 50 )
            {
                result = url.substring(0, 50) + "..."
            }
        }

        return result
    }

    def list(String tag, String linksofuser)
    {
        log.info "calling list with connected user " + springSecurityService.getPrincipal().username + ", tag : " + tag + ", user : " + linksofuser

        def _linksOfUser = linksofuser
        if ( _linksOfUser == null )
        {
            _linksOfUser = springSecurityService.getPrincipal().username
        }

        def connectedPerson = Person.findByUsername(springSecurityService.getPrincipal().username)

        return new ModelAndView("/link/list",
                                [linksOfUser : _linksOfUser,
                                 tag: tag,
                                 isOwner : springSecurityService.getPrincipal().username == _linksOfUser,
                                 allLinksPrivate : (LinkPrivacyPolicy.ALL_LOCKED == connectedPerson.privacyPolicy),
                                 searchType : "user-oriented",
                                 isGlobal : false])
    }

    def recentsLinks()
    {
        return new ModelAndView("/link/list",
                                [linksOfUser : "",
                                 tag: "",
                                 isOwner : false,
                                 allLinksPrivate : false,
                                 searchType : "global",
                                 isGlobal : true])
    }
        /**
     * filter the links and returns them as JSON result
     * @param token
     * @param read_status : all, read or unread
     * @return
     */
    def filter(String token, String read_status, String sortBy, String sortType, int page, String linksofuser, String searchType)
    {
        def start = System.currentTimeMillis();
        log.info "calling filter from LinkController with filter equals to " + token + ", read status : " + read_status +
                 ", sort by " + sortBy + " " + sortType + ", page = " + page + ", links of user = " + linksofuser + ", with search type = " + searchType

        def userAskedIsConnectedUser = springSecurityService.getPrincipal().username == linksofuser

        def queryLinks = Collections.emptyList()

        def isGlobalSearch = "global" == searchType

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

        if ( isGlobalSearch )
        {
            _sortBy = "creationDate"
            _sortType = "desc"
            read = true
            unread = true
        }

        def policy = LinkPrivacyPolicy.ALL_PUBLIC

        if ( read || unread ) // no need to launch the request if ! read && ! unread
        {
            if ( ! userAskedIsConnectedUser && ! isGlobalSearch )
            {
                // load asked user to see if connected user has the right to see his links
                def askedPerson = Person.findByUsername(linksofuser)

                if ( askedPerson != null && askedPerson.privacyPolicy != null )
                {
                    policy = askedPerson.privacyPolicy
                }
            }

            if ( ! isGlobalSearch && ! userAskedIsConnectedUser && policy == LinkPrivacyPolicy.ALL_LOCKED )
            {
                response.setStatus(500)
                render this.error(this.message(code: "service.link.filter.allLinksLocked")) as JSON
                success = false
            }
            else
            {
                def queryParams = [max: linksPerPage, offset: (page - 1) * linksPerPage, sort: _sortBy, order: _sortType]

                // oblig?? d'initialiser query a un truc non null
                // sinon, la cr??ation d'une requete avec plusieurs where foire
                def query = Link.where {
                }

                if ( isGlobalSearch )
                {
                    log.info "applying criteria 'not links of connected user + public'"
                    query = query.where {
                        person {
                            privacyPolicy == LinkPrivacyPolicy.ALL_PUBLIC && username != springSecurityService.principal.username
                        }
                        locked == false
                    }
                }
                else
                {
                    log.info "applying criteria about username with " + linksofuser
                    query = query.where { person.username == linksofuser }
                }

                // desactive : en attente d'impl??mentation
                /*if ( ! userAskedIsConnectedUser && policy == LinkPrivacyPolicy.LINK_PER_LINK )
                {
                    query = query.where {
                        locked == false
                    }
                } */

                def tokens = linkBuilderService.extractTags(token)

                log.info "tokens size : " + tokens.size()
                if ( tokens != null && tokens.size() > 0)
                {
                    if ( tokens.size() == 1 )
                    {
                        log.info "applying criteria on tag like '" + tokens.first() + "%'"
                        query = query.where {
                            tags {
                                label =~ tokens.first() + "%"
                            }
                        }
                    }
                    else
                    {
                        response.setStatus(500)
                        render this.error(this.message(code: "service.link.filter.oneTagAllowed")) as JSON
                        success = false
                    }
                }

                if ( ! isGlobalSearch )
                {
                    if ( ! read )
                    {
                        log.info "applying criteria on read = false"
                        query = query.where { read == false }
                    }
                    if ( ! unread )
                    {
                        log.info "applying criteria on read = true"
                        query = query.where { read == true }
                    }

                    if ( ! userAskedIsConnectedUser )
                    {
                        //
                    }
                }

                def query_start = System.currentTimeMillis();

                queryLinks = query.list(queryParams)

                log.info "query execution : " + (System.currentTimeMillis() - query_start) + " ms"
            }
        }

        if ( success )
        {
            log.info "query links found count : " + queryLinks.size()

            def pageError = false

            if ( page > 0 ) // called from infinite scroll
            {
                if ( queryLinks.isEmpty() )
                {
                    response.setStatus(404)
                    pageError = true
                }
            }

            if ( ! pageError )
            {
                render(contentType: "text/json") {
                    links = array{
                        for (a in queryLinks) {
                            item title: a.title,
                                 owner: a.person.username,
                                 read: a.read,
                                 url : a.url,
                                 readonly : (userAskedIsConnectedUser ? false : true),
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
            response.setStatus(500)
            msg = this.error(this.message(code: "service.link.addUrl.invalidUrl"))
        }
        else
        {
            def url = params.url

            // if params.url does not contains ://, then add http://
            if ( url.indexOf("://") == -1 )
            {
                log.warn("adding http:// to url without protocol : " + url)
                url = "http://" + url
            }

            def target = linkBuilderService.determineTarget(url)

            if ( target.error == null )
            {
                def connectedPerson = Person.findByUsername(springSecurityService.getPrincipal().username)

                try {

                    def _tag = (params.tag == null ? "" : params.tag.toLowerCase())

                    log.debug "creating detached link... with url : " + target.stringUrl
                    def newLink = new Link(url: target.stringUrl, fusionedTags: " " + _tag + " ", creationDate: new Date(), person: connectedPerson)
                    log.debug "detached link created"

                    linkBuilderService.complete(newLink, target)
                    log.debug "link completed"

                    linkBuilderService.addTags(newLink, params.tag)
                    log.debug "tags added to the link"

                    // check that this url does not already exist
                    if ( Link.findByPersonAndUrl(connectedPerson, newLink.url) != null )
                    {
                        log.debug "url " + newLink.url + " already exists"
                        response.setStatus(500)
                        msg = this.error(this.message(code: "service.link.addUrl.linkAlreadyExists", args: [this.formatUrl(params.url)]))
                    }
                    else
                    {
                        log.debug "saving new link..."
                        newLink.save(flush: true)
                        log.debug "new link saved"

                        if ( target.isClientError() || target.isServerError() )
                        {
                            msg = this.warning(this.message(code: "service.link.addUrl.linkCreatedWithoutAccess"))
                        }
                        else
                        {
                            msg = this.success(this.message(code: "service.link.addUrl.linkCreated"))
                        }
                    }
                }
                catch(TagException e)
                {
                    response.setStatus(500)
                    msg = this.error( ((TagException)e).getMessage() )
                }
                catch(Exception e)
                {
                    log.error(e.getClass().name + " with cause : " + e.getCause()?.getClass().name + " :: error while trying to save new link with url : " + params.url, e)
                    response.setStatus(500)
                    if ( e.getCause() != null )
                    {
                        /*if ( e.getCause() instanceof MalformedURLException )
                        {
                            msg = this.error(this.message(code: "service.link.addUrl.invalidUrlWithCause", args: [this.formatUrl(params.url), e.getCause().getMessage()]))
                        }
                        else */if ( e.getCause() instanceof UnknownHostException )
                        {
                            msg = this.error(this.message(code: "service.link.addUrl.unknownHost", args: [((UnknownHostException)e.getCause()).getMessage()]))
                        }
                    }

                    if ( msg == null )
                    {
                        // default message
                        msg = this.error(this.message(code: "service.link.addUrl.defaultError", args: [this.formatUrl(params.url)]))
                    }
                }
            }
            else
            {
                response.setStatus(500)

                switch (target.error)
                {
                    case TargetDeterminationError.INVALID_CONNECTION_TYPE :
                        msg = this.error(this.message(code: "service.link.addUrl.invalidConnectionType"))
                        break;
                    case TargetDeterminationError.EXCEPTION :
                        msg = this.error(this.message(code: "service.link.addUrl.defaultError", args: [this.formatUrl(params.url)]))
                        break;
                    case TargetDeterminationError.INFINITE_LOOP :
                        msg = this.error(this.message(code: "service.link.addUrl.redirectionLoop"))
                        break;
                    case TargetDeterminationError.TOO_MANY_LOOP :
                        msg = this.error(this.message(code: "service.link.addUrl.tooMuchRedirections"))
                        break;
                    case TargetDeterminationError.UNKNOWN_HOST_EXCEPTION :
                        msg = this.error(this.message(code: "service.link.addUrl.unknownHost", args: [((UnknownHostException)target.exception).getMessage()]))
                        break;
                    case TargetDeterminationError.MALFORMED_URL :
                        msg = this.error(this.message(code: "service.link.addUrl.invalidUrlWithCause", args: [this.formatUrl(params.url), target.exception.getMessage()]))
                        break;
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
                response.setStatus(500)
                render this.error(this.message(code: "service.link.delete.forbidden")) as JSON
            }
        }

        if (success)
        {
            render this.success(this.message(code: "service.link.delete.success")) as JSON
        }
        else
        {
            response.setStatus(500)
            render this.error(this.message(code: "service.link.delete.error")) as JSON
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
        new Exception().printStackTrace()
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
                    response.setStatus(500)
                    msg = this.error(this.message(code: "service.link.addTag.invalidTag"))
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
                        response.setStatus(500)
                        def i18nCode
                        if ( severallTagsToAdd )
                        {
                            i18nCode = "service.link.addTag.tagsExist"
                        }
                        else
                        {
                            i18nCode = "service.link.addTag.tagExists"
                        }

                        msg = this.error(this.message(code: i18nCode))
                    }
                    else
                    {
                        linkBuilderService.addTags(link, tagsToAdd.join(" "))
                        link.save(flush: true)

                        success = true
                        if ( severallTagsToAdd )
                        {
                            if ( tagsToAdd.size() < tagsToAddSize )
                            {
                                msg = this.warning(this.message(code: "service.link.addTag.someTagsAdded"))
                            }
                            else
                            {
                                msg = this.success(this.message(code: "service.link.addTag.tagsAdded"))
                            }
                        }
                        else
                        {
                            msg = this.success(this.message(code: "service.link.addTag.tagAdded"))
                        }
                    }
                }
            }
            else
            {
                response.setStatus(500)
                msg = this.error(this.message(code: "service.link.addTag.forbidden"))
            }
        }
        else
        {
            response.setStatus(500)
            msg = this.error(this.message(code: "service.link.addTag.error"))
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
                    response.setStatus(500)
                    render this.error(this.message(code: "service.link.deleteTag.tagDoesNotExist", args: [tag])) as JSON
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
                response.setStatus(500)
                render this.error(this.message(code: "service.link.deleteTag.forbidden")) as JSON
            }
        }

        if (success)
        {
            render this.success(this.message(code: "service.link.deleteTag.success", args: [tag])) as JSON
        }
        else
        {
            response.setStatus(500)
            render this.error(this.message(code: "service.link.deleteTag.error")) as JSON
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
            response.setStatus(500)
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
                    msg = this.success(this.message(code: "service.link.updateNote.success"))
                    success = true
                }
                catch (Exception e)
                {
                    log.error("error while trying to update the note", e)
                }
            }
            else
            {
                response.setStatus(500)
                msg =  this.error(this.message(code: "service.link.updateNote.forbidden"))
            }
        }

        if (! success && msg == null)
        {
            response.setStatus(500)
            msg = this.error(this.message(code: "service.link.updateNote.error"))
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
                msg = this.success(this.message(code: "service.link.changeReadAttribute.success", args: [readType]))
                success = true
            }
            else
            {
                msg =  this.error(this.message(code: "service.link.changeReadAttribute.forbidden"))
            }
        }
        if ( ! success && msg == null )
        {
            response.setStatus(500)
            msg = this.error(this.message(code: "service.link.changeReadAttribute.error", args: [readType]))
        }

        render msg as JSON
    }

    /**
     *
     */
    def getTagsCloud(String username)
    {
        log.info "calling getTagsCloud for user : " + username

        def results = new ArrayList()

        def iterator

        if ( username )
        {
            if ( springSecurityService.principal.username == username ) // user connected
            {
                iterator = Tag.createCriteria().list {
                    links {
                        person
                                {
                                    eq('username', username)
                                }
                    }
                    projections{
                        groupProperty('label')
                        rowCount('total') //alias given to count
                    }
                }
            }
            else
            {
                iterator = Tag.createCriteria().list {
                    links {
                        person
                        {
                            eq('username', username)
                            eq('privacyPolicy', LinkPrivacyPolicy.ALL_PUBLIC)
                        }
                    }
                    projections{
                        groupProperty('label')
                        rowCount('total') //alias given to count
                    }
                }
            }
        }
        else
        {
            // global search
            iterator = Tag.createCriteria().list {
                links {
                    person
                            {
                                ne('username', springSecurityService.principal.username)
                                eq('privacyPolicy', LinkPrivacyPolicy.ALL_PUBLIC)
                            }
                }
                projections{
                    groupProperty('label')
                    rowCount('total') //alias given to count
                }
            }
        }

        if ( iterator )
        {
            iterator.each {
                log.info "consider tag : " + it[0] + " with an occurrence of " + it[1]
                results.add(new TagWeight(tag: it[0], weight: it[1]))
            }
        }

        render results as JSON
    }

    def importLink(Long id)
    {
        log.info "calling importLink with id : " + id
        def message = null;

        def link = Link.findById(id)
        if ( link )
        {
            if ( link.person.username == springSecurityService.principal.username )
            {
                response.setStatus(500)
                message = this.error(this.message(code: "service.link.importLink.linkExistsForConnectedUser"))
            }
            else
            {
                def connectedUser = Person.findByUsername(springSecurityService.getPrincipal().username)

                if ( Link.findByUrlAndPerson(link.url, connectedUser) != null )
                {
                    response.setStatus(500)
                    message = this.error(this.message(code: "service.link.importLink.linkExistsForConnectedUser"))
                }
                else
                {
                    // clone link
                    Link result = linkBuilderService.clone(link)
                    result.creationDate = new Date()
                    result.locked = Boolean.FALSE
                    result.read = Boolean.FALSE
                    result.person = connectedUser

                    result.save(flush:  true)

                    message = this.success(this.message(code: "service.link.importLink.linkImported"))
                }
            }
        }
        else
        {
            response.setStatus(500)
            message = this.error(this.message(code: "service.link.importLink.linkDoesNotExist"))
            message = this.error("Link not found");
        }

        render message as JSON
    }

    def tags(String value)
    {
        log.info "calling tags with value : " + value

        def results = []

        if ( value )
        {
            def tagsToAdd = linkBuilderService.extractTags(value)

            if ( tagsToAdd && tagsToAdd.size() == 1 )
            {
                def queryParams = [max: 20]

                def q = Tag.createCriteria()

                def iterator = q.list(queryParams) {
                    and
                    {
                        ilike('label', "%" + tagsToAdd.first() + "%")
                    }
                }

                iterator.each {
                    results.add(it.label)
                }

                // sort result
                results.sort {
                    a, b ->
                        if ( value == a )
                        {
                            -1
                        }
                        else if ( value == b )
                        {
                            1
                        }
                        else
                        {
                            a <=> b
                        }
                }
            }
        }

        log.info "founds " + results.size() + " tags results"

        if ( results.isEmpty() )
        {
            response.setStatus(404)
        }
        else
        {
            render results as JSON
        }
    }

    def shortenUrl(String url)
    {
        log.info "calling shorten url with url " + url
        def urlResource = shortenerService.shorten(url)
        log.info "returning " + urlResource.shortUrl
        render urlResource.shortUrl
    }
}
