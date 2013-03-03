import grails.util.GrailsUtil
import linkguardian.Link
import linkguardian.LinkPrivacyPolicy
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

    def createFakeLink(String _tags, Note _note, Person _person, Boolean _read = false, String name, boolean locked = false)
    {
        def newLink
        try {
            newLink = new Link(url: "url_" + name, creationDate: new Date(), read:  _read, person: _person,
                               domain: "domain_" + name, title: "title_" + name, locked: locked)

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
        adminTwitted.token = "55181004-xY4Auj3gdik5GbwUS4JNuJbRRkvnybPdw0MCx7V61"
        adminTwitted.tokenSecret = "l95f3RDrEeGVJtyiWUxy1gOAbPUH4oG1sGwC3dDWiU"
        adminTwitted.user = admin
        adminTwitted.save(flush: true)

        switch (Environment.current)
        {
            case Environment.DEVELOPMENT:

                // links for admin
                for (i in 1..200)
                {
                    this.createFakeLink("", Note.valueOf("Note_" + (i % 6)), admin, Math.random() > 0.5, i.toString())
                }

                // fake user 1
                def user1 = new Person(username: 'OlivierCroisier', enabled: true, password: 'password')
                user1.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                user1 = user1.save(flush: true)
                PersonRole.create user1, userRole, true
                PersonRole.create user1, twitterRole, true

                this.createFakeLink("", Note.Note_0, user1, false, "not_locked", false)
                this.createFakeLink("", Note.Note_0, user1, false, "locked", true)

                // fake user 2
                def user2 = new Person(username: 'fonfec78', enabled: true, password: 'password')
                user2.privacyPolicy = LinkPrivacyPolicy.ALL_LOCKED
                user2 = user2.save(flush: true)
                PersonRole.create user2, userRole, true
                PersonRole.create user2, twitterRole, true

                this.createFakeLink("", Note.Note_0, user2, false, "not_locked", false)
                this.createFakeLink("", Note.Note_0, user2, false, "locked", true)

                // fake user 3
                def user3 = new Person(username: 'nodejs', enabled: true, password: 'password')
                user3.privacyPolicy = LinkPrivacyPolicy.LINK_PER_LINK
                user3 = user3.save(flush: true)
                PersonRole.create user3, userRole, true
                PersonRole.create user3, twitterRole, true

                this.createFakeLink("", Note.Note_0, user3, false, "not_locked", false)
                this.createFakeLink("", Note.Note_0, user3, false, "locked", true)

                def twitterUsers = ['jaraparilla', 'glaforge', 'mathof1', 'wernerkeil', 'drenoux', 'xavroy',
                                    'nfs_lu', 'vincent_germain', 'LahautXavier', 'caroline_simon', 'renox57',
                                    'JeromeGodard', 'osaucin', 'Tibooo', 'insilencio', 'yannick_muller', 'JavaFreelance',
                                    'javatv', 'Xebia', 'builddoctor', 'AlexisHassler', 'elsasspower', 'FrancoisMarot',
                                    'ictjob_lu', 'efruh', 'Ali_Riad', 'Naooj', 'agnes_crepet', 'ericreboisson', 'ZenikaIT',
                                    'TofDemulder', 'CTGLuxembourg', 'Logica', 'aheritier', 'CTGinc', 'thenrion',
                                    'webcuriousanima', 'eucalyptus', 'xavroy', 'DataStax', 'CloudBees', 'nantesjug', 'AndroidDev']

                twitterUsers.each{
                    def userF = new Person(username: it, enabled: true, password: 'password')
                        userF.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                        userF = userF.save(flush: true)
                        PersonRole.create userF, userRole, true
                        PersonRole.create userF, twitterRole, true
                }

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
