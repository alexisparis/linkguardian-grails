import linkguardian.Link
import linkguardian.Note
import linkguardian.Person
import linkguardian.Role
import linkguardian.Person
import linkguardian.PersonRole

class BootStrap {

  def linkBuilderService

    def createLink(String _url, String _tags, Note _note, Boolean _read = false)
    {
        try {
            def newLink = new Link(url: _url, fusionedTags: _tags, creationDate: new Date(), read:  _read)
            newLink.note = _note
            linkBuilderService.complete(newLink)
            newLink.save(flush: true)
        }
        catch(Exception e)
        {
            log.error("error while creating link with url '" + _url + "'", e)
        }
    }

    def init    = { servletContext ->
        def newLink

        this.createLink("http://www.privatesportshop.com", " sport shop nike adidas reebok a ", Note.Note_2)

        this.createLink("http://www.brandalley.fr", " shop marque ", Note.Note_4)

        this.createLink("http://blog.knoldus.com/2013/01/12/akka-futures-in-scala-with-a-simple-example/", " scala akka ", Note.Note_0, true)

        this.createLink("http://korben.info/idees-raspberry-pi.html", " scala akka ", Note.Note_0)

        this.createLink("http://use-the-index-luke.com/sql/preface", " sql ", Note.Note_0)

        this.createLink("http://www.house-fr.com/dossiers/Les_baskets_de_House", " basket docteur house ", Note.Note_0, true)

        this.createLink("http://arodrigues.developpez.com/tutoriels/java/presentation-apache-jmeter-partie1/", " jmeter ", Note.Note_0, true)

        this.createLink("http://aravindamadusanka.blogspot.fr/2012/08/how-to-use-apache-jmeter-for-web.html", " jmeter ", Note.Note_0)

        this.createLink("http://java.dzone.com/articles/introducing-spring-integration", " spring integration ", Note.Note_0)

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

        def adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
        def userRole = new Role(authority: 'ROLE_USER').save(flush: true)
        def twitterRole = new Role(authority: 'ROLE_TWITTER').save(flush: true)

        def testUser = new Person(username: 'me', enabled: true, password: 'password')
        testUser.save(flush: true)

        PersonRole.create testUser, adminRole, true
        PersonRole.create testUser, userRole, true
        PersonRole.create testUser, twitterRole, true

        assert Person.count() == 1
        assert Role.count() == 3
        assert PersonRole.count() == 3
    }
    def destroy = {}
}
