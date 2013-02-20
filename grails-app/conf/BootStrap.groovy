import grails.util.GrailsUtil
import linkguardian.Link
import linkguardian.Note
import linkguardian.Person
import linkguardian.Role
import linkguardian.Person
import linkguardian.PersonRole
import grails.util.Environment

class BootStrap {

  def linkBuilderService

    def createLink(String _url, String _tags, Note _note, Person _person, Boolean _read = false)
    {
        def newLink
        try {
            newLink = new Link(url: _url, creationDate: new Date(), read:  _read, person: _person)
            newLink.note = _note
            linkBuilderService.complete(newLink)
            linkBuilderService.addTags(newLink, _tags)
            newLink = newLink.save(flush: true)
        }
        catch(Exception e)
        {
            log.error("error while creating link with url '" + _url + "'", e)
        }

        return newLink
    }

    def init    = { servletContext ->

        def adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
        def userRole = new Role(authority: 'ROLE_USER').save(flush: true)
        def twitterRole = new Role(authority: 'ROLE_TWITTER').save(flush: true)

        switch (Environment.current) {
            case Environment.DEVELOPMENT:

                def admin = new Person(username: 'paris_alex', enabled: true, password: 'password')
                admin = admin.save(flush: true)

                PersonRole.create admin, adminRole, true
                PersonRole.create admin, userRole, true
                PersonRole.create admin, twitterRole, true

                def user = new Person(username: 'user', enabled: true, password: 'password')
                user = user.save(flush: true)

                PersonRole.create user, userRole, true
                PersonRole.create user, twitterRole, true

                assert Person.count() == 2
                assert Role.count() == 3
                assert PersonRole.count() == 5

                this.createLink("http://www.privatesportshop.com", "sport shop nike adidas reebok", Note.Note_2, admin)
                this.createLink("http://blog.knoldus.com/2013/01/12/akka-futures-in-scala-with-a-simple-example/", "scala akka", Note.Note_0, admin)
                this.createLink("http://www.brandalley.fr", "shop marque", Note.Note_4, admin)
                this.createLink("http://aravindamadusanka.blogspot.fr/2012/08/how-to-use-apache-jmeter-for-web.html", "shop reebok", Note.Note_0, admin)
                this.createLink("http://java.dzone.com/articles/introducing-spring-integration", "shop reebok", Note.Note_0, admin)

                this.createLink("http://www.brandalley.fr", "shop marque", Note.Note_4, user)
                this.createLink("http://www.m6.fr", "shop marque", Note.Note_2, user)


        /*


        admin.addToLinks(this.createLink("http://korben.info/idees-raspberry-pi.html", " scala akka ", Note.Note_0))

        admin.addToLinks(this.createLink("http://use-the-index-luke.com/sql/preface", " sql ", Note.Note_0))

        admin.addToLinks(this.createLink("http://www.house-fr.com/dossiers/Les_baskets_de_House", " basket docteur house ", Note.Note_0, true))

        admin.addToLinks(this.createLink("http://arodrigues.developpez.com/tutoriels/java/presentation-apache-jmeter-partie1/", " jmeter ", Note.Note_0, true))

        admin.addToLinks(this.createLink("http://aravindamadusanka.blogspot.fr/2012/08/how-to-use-apache-jmeter-for-web.html", " jmeter ", Note.Note_0))

        admin.addToLinks(this.createLink("http://java.dzone.com/articles/introducing-spring-integration", " spring integration ", Note.Note_0))

        admin.save(flush:  true)
        */

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
        }
    }
    def destroy = {}
}
