package linkguardian

import grails.converters.JSON
import grails.util.GrailsUtil

import java.util.logging.Level

/**
 *
 * see http://viralpatel.net/blogs/first-play-framework-gae-siena-application-tutorial-example/
 */
class LinkController
{
    static defaultAction = "list"

    def linkBuilderService

    def success(String message)
    {
        return new linkguardian.Message(message : message, level : linkguardian.Level.SUCCESS)
    }

    def error(String message)
    {
        return new linkguardian.Message(message : message, level : linkguardian.Level.ERROR)
    }

    def warning(String message)
    {
        return new linkguardian.Message(message : message, level : linkguardian.Level.WARNING)
    }

    def list()
    {
        println("calling list from LinkController")
    }

    /**
     * filter the links and returns them as JSON result
     * @param token
     * @param sort
     * @param read
     * @param unread
     * @return
     */
    def filter(String token, String sort, String read, String unread)
    {
        println("calling filter from LinkController with filter equals to " + token + ", sort=" + sort + ", read=" + read + ", unread=" + unread)

        def tokenConvey = { String _fusionedTags, String _token ->
            def result = true

            println "a"
            if (_token?.length() > 0)
            {

                println "b"
                _token.toUpperCase().tokenize(' ').each {
                    if (result)
                    {
                        println "c"
                        println "   " + _fusionedTags + "#"
                        println "   " + it
                        if (!_fusionedTags.contains(" " + it + " "))
                        {
                            result = false
                        }
                    }
                }
            }

            result
        }

        Collection<Link> queryLinks = Link.withCriteria {
            tokenConvey("fusionedTags", token)
        }                                 .
                sort { it.creationDate }  .grep()

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
        println "calling addUrl"

        def newLink = new Link(url: params.url, fusionedTags: " " + params.tag.toUpperCase() + " ", creationDate: new Date())

        linkBuilderService.complete(newLink)

        newLink.save(flush: true)

        render success("the link has been created") as JSON
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
        println "trying to delete link with id : " + id;

        Link link = Link.get(id);
        if (link != null)
        {
            link.delete()
            success = true
        }

        if (success)
        {
            render success("the link has been deleted") as JSON
        }
        else
        {
            render error("error while trying to delete the link") as JSON
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
        println "calling addTag for " + id + " for tag " + tag
        def msg

        Link link = Link.get(id)
        if (link != null && tag != null)
        {
            def _tag = tag
            Set<String> tokens = new LinkedHashSet<String>(link.fusionedTags.tokenize())
            if (tokens.add(_tag))
            {
                link.fusionedTags = " " + tokens.join(" ") + " "
                link.save()
                msg = success("the tag has been added")
            }
            else
            {
                response.setStatus(406)
                msg = error("the tag already exist")
            }
        }

        if (msg == null)
        {
            msg = error("error while trying to add the new tag")
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
        println "calling deleteTag for " + id + " for tag " + tag
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
            render success("the tag has been deleted") as JSON
        }
        else
        {
            render error("error while trying to delete the tag") as JSON
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

        def msg = null

        if (link != null)
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
                msg = success("the note has been updated")
            }
            catch (Exception e)
            {
                println e
            }
        }

        if (msg == null)
        {
            msg = error("error while trying to update the note")
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
        def message = null
        def link = Link.get(id)

        if ( link != null )
        {
            link.read = value
            link.save()
            message = success("the link has been marked as " + (value ? "read" : "unread"))
        }
        if ( message == null )
        {
            message = error("error while trying to mark the link as " + (value ? "read" : "unread"))
        }

        render message as JSON
    }
}
