import linkguardian.Link
import linkguardian.Note

class BootStrap {

  def linkBuilderService

    def init    = { servletContext ->
      def newLink

      newLink = new Link(url: "http://www.privatesportshop.com", fusionedTags: " sport shop nike adidas reebok a ", creationDate: new Date())
      newLink.note = Note.Note_2
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://www.brandalley.fr", fusionedTags: " shop marque ", creationDate: new Date())
      newLink.note = Note.Note_4
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      //newLink = new Link(url: "http://www.laredoute.fr", fusionedTags: " ", creationDate: new Date())
      //newLink.note = Note.Note_5
      //linkBuilderService.complete(newLink)
      //newLink.save(flush: true)

      //newLink = new Link(url: "http://www.lequipe.fr", fusionedTags: " sport nba ligue1 ligue2 badminton rugby ", creationDate: new Date())
      //newLink.note = Note.Note_0
      //linkBuilderService.complete(newLink)
      //newLink.save(flush: true)

      //newLink = new Link(url: "http://www.dzone.com/links/r/becomeunbecome_discovering_akka_scala_topics.html", fusionedTags: " scala akka ", creationDate: new Date())
      //newLink.note = Note.Note_0
      //linkBuilderService.complete(newLink)
      //newLink.save(flush: true)

      newLink = new Link(url: "http://blog.knoldus.com/2013/01/12/akka-futures-in-scala-with-a-simple-example/", fusionedTags: " scala akka ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://korben.info/idees-raspberry-pi.html", fusionedTags: " scala akka ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://use-the-index-luke.com/sql/preface", fusionedTags: " sql ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://www.house-fr.com/dossiers/Les_baskets_de_House", fusionedTags: " basket docteur house ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://arodrigues.developpez.com/tutoriels/java/presentation-apache-jmeter-partie1/", fusionedTags: " jmeter ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://aravindamadusanka.blogspot.fr/2012/08/how-to-use-apache-jmeter-for-web.html", fusionedTags: " jmeter ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)

      newLink = new Link(url: "http://java.dzone.com/articles/introducing-spring-integration", fusionedTags: " spring integration ", creationDate: new Date())
      newLink.note = Note.Note_0
      linkBuilderService.complete(newLink)
      newLink.save(flush: true)
    }
  def   destroy = {}
}
