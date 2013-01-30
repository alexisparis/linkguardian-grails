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

  def list()
  {
    println("calling list from LinkController")
  }

  def addUrl()
  {
    //TODO : check que l'url n'existe pas déjà pour l'utilisateur connecté
    println "calling addUrl"

    def newLink = new Link(url: params.url, fusionedTags: " " + params.tag.toUpperCase() + " ", creationDate: new Date())

    linkBuilderService.complete(newLink)

    newLink.save(flush: true)

    render new linkguardian.Message(message: "the link has been created", level : linkguardian.Level.SUCCESS) as JSON
  }

  def delete(String id)
  {
    def success = false

    // TODO : check if the link is linked ot he connected user
    println "trying to delete link with id : " + id;

    Link link = Link.get(id);
    if ( link != null )
    {
      link.delete()
      success = true
    }

    if ( success )
    {
      render new linkguardian.Message(message: "the link has been deleted", level : linkguardian.Level.SUCCESS) as JSON
    }
    else
    {
      render new linkguardian.Message(message: "error while trying to delete the link", level : linkguardian.Level.WARNING) as JSON
    }
  }

  def deleteTag(String id, String tag)
  {
    println "calling deleteTag for " + id + " for tag " + tag
    def success = false

    Link link = Link.get(id)
    if ( link != null && tag != null )
    {
      def _tag = tag
      List<String> tokens = link.fusionedTags.tokenize()
      if ( tokens.remove(_tag) )
      {
        link.fusionedTags = " " + tokens.join(" ") + " "
        link.save()
        success = true
      }
    }

    if ( success )
    {
      render new linkguardian.Message(message: "the tag has been deleted", level : linkguardian.Level.SUCCESS) as JSON
    }
    else
    {
      render new linkguardian.Message(message: "error while trying to delete the tag", level : linkguardian.Level.WARNING) as JSON
    }
  }

  def updateNote(String id, Integer oldScore, Integer newScore)
  {
    println "calling update note from " + oldScore + " to " + newScore

    def link = Link.get(id);

    def msg = null

    if ( link != null )
    {
      def _score = newScore
      if ( _score == null )
        _score = 0

      _score = Math.max(0, Math.min(_score, 5))

      link.note = Note.valueOf(Note.class, "Note_" + _score)
      link.save()
      msg = new linkguardian.Message(message: "the note has been updated", level : linkguardian.Level.SUCCESS)
    }

    if ( msg == null )
    {
      msg = new linkguardian.Message(message: "error hile trying to update the note", level : linkguardian.Level.WARNING)
    }

    render msg as JSON
  }

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
}
