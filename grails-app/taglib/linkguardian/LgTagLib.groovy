package linkguardian

class LgTagLib {

    static namespace = "lg"

    def springSecurityService

    def user_privacy = { attrs, body ->
        def user = Person.findByUsername(springSecurityService.principal.username)
        if ( user )
        {
            out << user.privacyPolicy
        }
    }
}
