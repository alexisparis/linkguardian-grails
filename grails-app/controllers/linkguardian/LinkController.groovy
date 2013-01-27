package linkguardian

import grails.converters.JSON
import grails.util.GrailsUtil

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
    println "calling addUrl"

    def newLink = new Link(url: params.url, fusionedTags: " " + params.tag.toUpperCase() + " ", creationDate: new Date())

    linkBuilderService.complete(newLink)

    newLink.save(flush: true)
    println "new link saved"
    render params.url + " saved !!"
  }

  def delete(String id)
  {
    println "trying to delete link with id : " + id;

    Link link = Link.get(id);
    link?.delete();

    render "link " + id + " has been deleted"
  }

  def filter(String token, Boolean archived)
  {
    println("calling filter from LinkController with filter equals to " + token + " and  archived = " + archived)

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
            println "   " + _fusionedTags
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
      eq "archived", archived && tokenConvey("fusionedTags", token)
    }                                 .
            sort { it.creationDate }  .grep()

    response.contentType = "text/json"
    render queryLinks as JSON
  }
}
