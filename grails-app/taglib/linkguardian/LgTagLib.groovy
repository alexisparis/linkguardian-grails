package linkguardian

import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.springframework.security.core.context.SecurityContextHolder

class LgTagLib {

    static namespace = 'lg'

    def springSecurityService

    def ifAdministrator = { attrs, body ->

        println "calling ifAdministrator"
        if (springSecurityService.isLoggedIn())
        {
            SpringSecurityUtils.getPrincipalAuthorities().each {
                println "   " + it.authority
            }

            SecurityContextHolder.getContext().getAuthentication().getAuthorities().each {
                println "   a : " + it.authority
            }

            println "principal : " + SecurityContextHolder.getContext().authentication.principal
        }
        println "has admin ? " + SpringSecurityUtils.ifAllGranted("ROLE_ADMIN")
        println "has user  ? " + SpringSecurityUtils.ifAllGranted("ROLE_USER")
        println "has twitter ? " + SpringSecurityUtils.ifAllGranted("ROLE_TWITTER")
        if (SpringSecurityUtils.ifAllGranted("ROLE_ADMIN"))
        {
            out << body()
        }
    }

    def username = { attrs, body ->
        if ( springSecurityService.isLoggedIn() )
        {
            out << springSecurityService.principal.username
        }
    }

}
