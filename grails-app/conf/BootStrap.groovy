import linkguardian.Link
import linkguardian.Note

class BootStrap {

  def linkBuilderService

    def init    = { servletContext ->
      def newLink = new Link(url: "http://www.lequipe.fr", fusionedTags: " sport nba ligue1 ligue2 badminton rugby ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://www.privatesportshop.com", fusionedTags: " sport shop nike adidas reebok a ", creationDate: new Date())
      newLink.note = Note.Note_2
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://www.brandalley.fr", fusionedTags: " shop marque ", creationDate: new Date())
      newLink.note = Note.Note_4
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://www.laredoute.fr", fusionedTags: " shop marque ", creationDate: new Date())
      newLink.note = Note.Note_5
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)
    }
  def   destroy = {}
}
