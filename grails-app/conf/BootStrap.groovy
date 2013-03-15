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

    def createFakeLink(String _tags, Note _note, Person _person, Boolean _read = false, String name, boolean locked, String _desc = null)
    {
        def newLink
        try {
            newLink = new Link(url: "url_" + name, creationDate: new Date(), read:  _read, person: _person,
                               domain: "domain_" + name, title: "title_" + name, locked: locked)

            def desc

            if ( _desc )
            {
                desc = _desc
            }
            else
            {
                desc = (("description_" + name + " ") * ((Math.random() * 25.0) + 1).intValue())
                if ( desc.length() > 200 )
                {
                    desc = desc.substring(0, 200)
                }
            }

            newLink.description = desc
            newLink.note = _note

            linkBuilderService.addTags(newLink, _tags)
            newLink = newLink.save(flush: true)
        }
        catch(Exception e)
        {
            log.error("error while creating link with name '" + name + "'", e)
        }

        return newLink
    }

    def init    = { servletContext ->

        def adminRole = Role.findByAuthority('ROLE_ADMIN')
        def userRole = Role.findByAuthority('ROLE_USER')
        def twitterRole = Role.findByAuthority('ROLE_TWITTER')

        if ( adminRole == null )
        {
            adminRole = new Role(authority: 'ROLE_ADMIN').save(flush: true)
        }
        if ( userRole == null )
        {
            userRole = new Role(authority: 'ROLE_USER').save(flush: true)
        }
        if ( twitterRole == null )
        {
            twitterRole = new Role(authority: 'ROLE_TWITTER').save(flush: true)
        }

        def admin = Person.findByUsername('paris_alex')

        if ( admin == null )
        {
            admin = new Person(username: 'paris_alex', enabled: false, password: '88f56921aa7f1a9372c9ae0e1f221f2e1c6dac7c8c6676d6ce521852bd06781b')
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
        }

        switch (Environment.current)
        {
            case Environment.TEST:

                if ( false ) // test de charge de la db
                {
                    def users = ['Norbert', "Elisa", "Isidore", "Bertrand", "Sophie", "Walter"]
                    def tags = ['tv', 'sport', 'shopping', 'basket', 'nba', 'vente']

                    Person user
                    def username

                    def time = System.currentTimeMillis()

                    (1..200).each {
                        if ( (it % 10) == 0 )
                        {
                            println "creating user n°" + it
                        }
                        username = users[(int)(Math.random() * users.size())] + "_" + it
                        user = new Person(username: username, enabled: true, password: 'password')
                        user.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                        user = user.save(flush: true)
                        PersonRole.create user, userRole, true
                        PersonRole.create user, twitterRole, true

                        // create links
                        (1..50).each { i ->

                            def links = []

                            1..(Math.random() * 5).each{ j ->
                                links.add( tags[ (int)(Math.random() * tags.size()) ] )
                            }

                            this.createFakeLink(" " + links.join(" ") + " ", Note.Note_0, user, true, "name_" + i, false)
                        }
                    }

                    println "initialization made in " + ((System.currentTimeMillis() - time) / 1000) + " secondes"
                }
                else
                {
                    this.createFakeLink(" a ", Note.Note_2, admin, false, "unread_link", false, "unread description")
                    this.createFakeLink(" b c ", Note.Note_2, admin, false, "unread_link_2", false, "unread description 2")
                    this.createFakeLink(" a c ", Note.Note_4, admin, true, "read_link", false, "read description")
                    this.createFakeLink(" c ", Note.Note_5, admin, true, "read_link_2", false, "read description 2")

                    def user1 = new Person(username: 'OlivierCroisier', enabled: true, password: 'password')
                    user1.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                    user1 = user1.save(flush: true)
                    PersonRole.create user1, userRole, true
                    PersonRole.create user1, twitterRole, true
                    this.createFakeLink(" 1 ", Note.Note_1, user1, true, "read_from_olivier", false, "desc")
                    this.createFakeLink(" 2 ", Note.Note_1, user1, false, "unread_from_olivier", false, "desc")

                    def user2 = new Person(username: 'fonfec_57', enabled: true, password: 'password')
                    user2.privacyPolicy = LinkPrivacyPolicy.ALL_LOCKED
                    user2 = user2.save(flush: true)
                    PersonRole.create user2, userRole, true
                    PersonRole.create user2, twitterRole, true
                    this.createFakeLink(" 1 ", Note.Note_1, user2, true, "read_from_fonfec", false, "desc")
                    this.createFakeLink(" 2 ", Note.Note_1, user2, false, "unread_from_fonfec", false, "desc")

                    def user3 = new Person(username: 'totor', enabled: true, password: 'password')
                    user3.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                    user3 = user3.save(flush: true)
                    PersonRole.create user3, userRole, true
                    PersonRole.create user3, twitterRole, true
                    this.createFakeLink(" 1 ", Note.Note_1, user3, true, "read_from_totor", false, "desc")
                    this.createFakeLink(" 2 ", Note.Note_1, user3, false, "unread_from_totor", false, "desc")
                }

                break
            case Environment.DEVELOPMENT:

                // links for admin
                for (i in 1..200)
                {
                    this.createFakeLink("", Note.valueOf("Note_" + (i % 6)), admin, Math.random() > 0.5, i.toString(), false)
                }

                // fake user 1
                def user1 = new Person(username: 'OlivierCroisier', enabled: true, password: 'password')
                user1.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                user1 = user1.save(flush: true)
                PersonRole.create user1, userRole, true
                PersonRole.create user1, twitterRole, true

                this.createFakeLink(" a b ", Note.Note_3, user1, false, "not_locked_1", false)
                this.createFakeLink(" a c ", Note.Note_4, user1, false, "not_locked_2", false)

                // fake user 2
                def user2 = new Person(username: 'fonfec78', enabled: true, password: 'password')
                user2.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                user2 = user2.save(flush: true)
                PersonRole.create user2, userRole, true
                PersonRole.create user2, twitterRole, true

                this.createFakeLink(" saucisson ", Note.Note_1, user2, false, "not_locked", false)
                this.createFakeLink(" cochon ", Note.Note_3, user2, false, "locked", true)

                // fake user 3
                def user3 = new Person(username: 'nodejs', enabled: true, password: 'password')
                user3.privacyPolicy = LinkPrivacyPolicy.ALL_PUBLIC
                user3 = user3.save(flush: true)
                PersonRole.create user3, userRole, true
                PersonRole.create user3, twitterRole, true

                this.createFakeLink(" toto ", Note.Note_5, user3, true, "not_locked_1", false)
                this.createFakeLink(" a ", Note.Note_1, user3, true, "not_locked_2", false)

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
