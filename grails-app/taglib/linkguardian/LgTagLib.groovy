package linkguardian

import org.codehaus.groovy.grails.commons.ConfigurationHolder

class LgTagLib {

    static namespace = "lg"

    def springSecurityService

    def user_privacy = { attrs, body ->
        if ( springSecurityService.isLoggedIn() )
        {
            def user = Person.findByUsername(springSecurityService.principal.username)
            if ( user )
            {
                out << user.privacyPolicy
            }
        }
    }

    def secureLink = { attrs, body ->
        def link = g.createLink(attrs)
        out << link.replace('http://','https://')
    }

    def contactMail = { attrs, body -> out << ConfigurationHolder.getConfig().contact.mail
    }
}
