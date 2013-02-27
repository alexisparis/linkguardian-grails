import grails.util.GrailsUtil
import linkguardian.Link
import linkguardian.Note
import linkguardian.Person
import linkguardian.Role
import linkguardian.Person
import linkguardian.PersonRole
import grails.util.Environment

class BootStrap {

  static String ADMIN = "ROLE_ADMIN"

  def linkBuilderService

    def createLink(String _url, String _tags, Note _note, Person _person, Boolean _read = false)
    {
        def newLink
        try {
            newLink = new Link(url: _url, creationDate: new Date(), read:  _read, person: _person)
            newLink.note = _note
            linkBuilderService.complete(newLink, "html")
            linkBuilderService.addTags(newLink, _tags)
            newLink = newLink.save(flush: true)
        }
        catch(Exception e)
        {
            log.error("error while creating link with url '" + _url + "'", e)
        }

        return newLink
    }

    def createFakeLink(String _tags, Note _note, Person _person, Boolean _read = false, String name)
    {
        def newLink
        try {
            newLink = new Link(url: "url_" + name, creationDate: new Date(), read:  _read, person: _person,
                               domain: "domain_" + name, title: "title_" + name)

            def desc = (("description_" + name + " ") * ((Math.random() * 25.0) + 1).intValue())
            if ( desc.length() > 200 )
            {
                desc = desc.substring(0, 200)
            }

            newLink.description = desc
            newLink.note = _note

            //linkBuilderService.addTags(newLink, _tags)
            newLink = newLink.save(flush: true)
        }
        catch(Exception e)
        {
            log.error("error while creating link with name '" + name + "'", e)
        }

        return newLink
    }

    def init    = { servletContext ->


        def adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
        def userRole = new Role(authority: 'ROLE_USER').save(flush: true)
        def twitterRole = new Role(authority: 'ROLE_TWITTER').save(flush: true)

        def admin = new Person(username: 'paris_alex', enabled: false, password: '88f56921aa7f1a9372c9ae0e1f221f2e1c6dac7c8c6676d6ce521852bd06781b')
        admin.accountExpired = false
        admin.accountLocked = false
        admin.passwordExpired = false
        admin = admin.save(flush: true)

        PersonRole.create admin, adminRole, true
        PersonRole.create admin, userRole, true
        PersonRole.create admin, twitterRole, true

        TwitterUser adminTwitted = new TwitterUser()
        adminTwitted.screenName = admin.username
        adminTwitted.uid = "55181004"
        adminTwitted.token = "55181004-xY4Auj3gdik5GbwUS4JNuJbRRkvnybPdw0MCx7V61"
        adminTwitted.tokenSecret = "l95f3RDrEeGVJtyiWUxy1gOAbPUH4oG1sGwC3dDWiU"
        adminTwitted.user = admin
        adminTwitted.save(flush:  true)

        switch (Environment.current) {
            case Environment.DEVELOPMENT:

                def user = new Person(username: 'user', enabled: true, password: 'password')
                user = user.save(flush: true)

                PersonRole.create user, userRole, true
                PersonRole.create user, twitterRole, true

//                this.createLink("http://www.privatesportshop.com", "sport shop nike adidas reebok", Note.Note_2, admin)
//                this.createLink("http://blog.knoldus.com/2013/01/12/akka-futures-in-scala-with-a-simple-example/", "scala akka", Note.Note_0, admin)
//                this.createLink("http://www.brandalley.fr", "shop marque", Note.Note_4, admin)
//                this.createLink("http://aravindamadusanka.blogspot.fr/2012/08/how-to-use-apache-jmeter-for-web.html", "shop reebok", Note.Note_0, admin)
//                this.createLink("http://java.dzone.com/articles/introducing-spring-integration", "shop reebok", Note.Note_0, admin)

                for(i in 1..200)
                {
                    this.createFakeLink("", Note.valueOf("Note_" + (i % 6)), admin, Math.random() > 0.5, i.toString())
                }

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
