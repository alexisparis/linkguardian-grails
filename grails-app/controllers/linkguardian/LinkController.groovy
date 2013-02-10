package linkguardian

import grails.converters.JSON
import grails.plugins.springsecurity.Secured
import grails.util.GrailsUtil

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
        println("calling list from LinkController")

        //println "current user : " + springSecurityService.getCurrentUser()
        println "principal : " + springSecurityService.getPrincipal()
    }

    /**
     * filter the links and returns them as JSON result
     * @param token
     * @param read
     * @param unread
     * @return
     */
    def filter(String token, String read, String unread)
    {
        log.info "calling filter from LinkController with filter equals to " + token + ", read : " + read + ", unread : " + unread

        def queryLinks = Collections.emptyList()

        if ( read || unread ) // no need to launch the request if ! read && ! unread
        {
            //todo : manage pagination
            def queryParams = [/*max: 3, offset: 2, */sort: "creationDate", order: "desc"]

            //TODO : filter by connected user
            def query = Link.where { 1 == 1 }

            if ( token )
            {
                query = query.where { fusionedTags =~ "% " + token.toUpperCase() + " %"}
            }

            if ( ! read )
            {
                query = query.where { read == false }
            }
            if ( ! unread )
            {
                query = query.where { read == true }
            }

            queryLinks = query.list(queryParams)
        }

        log.info "query links found count : " + queryLinks.size()

        response.contentType = "text/json"
        render queryLinks as JSON
    }

    /**
     * add a new link
     * @return
     */
    def addUrl()
    {
        //TODO : check que l'url n'existe pas déjà pour l'utilisateur connecté
        log.info "calling addUrl with url : " + params.url + " and tags : " + params.tag

        def msg

        def realUrl = null

        // manage redirect url
        def urls = new HashSet<String>()
        def redirectLimitCount = 10
        def redirectCount = 0
        def currentUrl = params.url

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
                   msg = this.error("invalid url ==> redirection loop")
                   break
               }

               redirectCount++
            }

            if ( realUrl == null )
            {
                if ( msg != null && redirectCount >= redirectLimitCount )
                {
                    response.status = 500
                    msg = this.error("invalid url ==> too many redirections")
                }
            }
        }
        catch(Exception e)
        {
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
            try {
               def newLink = new Link(url: realUrl, fusionedTags: " " + params.tag.toUpperCase() + " ", creationDate: new Date())

                linkBuilderService.complete(newLink)

                newLink.save(flush: true)

                msg = this.success("the link has been created")
            }
            catch(Exception e)
            {
                log.error(e.getClass().name + " :: error while trying to save new link with url : " + params.url, e)
                response.status = 500
                if ( e.getCause() != null )
                {
                    if ( e.getCause() instanceof MalformedURLException )
                    {
                        msg = this.error("The url '" + params.url + "' is invalid ==> '" + e.getCause().getMessage() + "'")
                    }
                    else if ( e.getCause() instanceof UnknownHostException )
                    {
                        msg = this.error("The host '" + ((UnknownHostException)e.getCause()).getMessage() + "' cannot be found")
                    }
                }

                if ( msg == null )
                {
                    // default message
                    msg = this.error("error while trying to save the link '" + params.url + "'")
                }
            }
        }

        render msg as JSON
    }

    /**
     * delete a link
     * @param id
     * @return
     */
    def delete(String id)
    {
        def success = false

        // TODO : check if the link is linked ot he connected user
        log.info "calling delete link with id : " + id;

        Link link = Link.get(id);
        if (link != null)
        {
            link.delete()
            success = true
        }

        if (success)
        {
            render this.success("the link has been deleted") as JSON
        }
        else
        {
            response.status = 500
            render this.error("error while trying to delete the link") as JSON
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

        Link link = Link.get(id)
        if (link != null && tag != null)
        {
            def _tag = tag.trim()

            if ( _tag.length() == 0 )
            {
                response.setStatus(500)
                msg = this.error("the tag is not valid")
            }
            else
            {
                List<String> tmp = _tag.tokenize();
                if ( tmp.size() == 1 )
                {
                    Set<String> tokens = new LinkedHashSet<String>(link.fusionedTags.tokenize())
                    if (tokens.add(_tag))
                    {
                        link.fusionedTags = " " + tokens.join(" ") + " "
                        link.save()
                        msg = this.success("the tag has been added")
                    }
                    else
                    {
                        response.setStatus(500)
                        msg = this.error("the tag already exist")
                    }
                }
                else
                {
                    response.status = 500
                    msg = this.error("You can only provide one tag at a time")
                }
            }
        }
        else
        {
            response.setStatus(500)
            msg = this.error("error while trying to add the new tag")
        }

        render msg as JSON
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
            def _tag = tag
            List<String> tokens = link.fusionedTags.tokenize()
            if (tokens.remove(_tag))
            {
                link.fusionedTags = " " + tokens.join(" ") + " "
                link.save()
                success = true
            }
        }

        if (success)
        {
            render this.success("the tag '" + tag + "' has been deleted") as JSON
        }
        else
        {
            response.status = 500
            render this.error("error while trying to delete the tag") as JSON
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
            try
            {   def _score = newScore
                if (_score == null)
                {
                    _score = 0
                }

                _score = Math.max(0, Math.min(_score, 5))

                link.note = Note.valueOf(Note.class, "Note_" + _score)
                link.save()
                msg = this.success("the note has been updated")
                success = true
            }
            catch (Exception e)
            {
                log.error("error while trying to update a note", e)
            }
        }

        if (! success && msg == null)
        {
            response.status = 500
            msg = this.error("error while trying to update the note")
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
        def message = null
        def link = Link.get(id)

        if ( link != null )
        {
            link.read = value
            link.save()
            message = this.success("the link has been marked as " + (value ? "read" : "unread"))
            success = true
        }
        if ( ! success && message == null )
        {
            response.status = 500
            message = this.error("error while trying to mark the link as " + (value ? "read" : "unread"))
        }

        render message as JSON
    }
}
