package linkguardian

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_USER'])
class PersonController extends MessageOrientedObject
{
    def springSecurityService

    def saveConfiguration()
    {
        log.info "calling saveConfiguration with privacy : " + params.privacy

        def person = Person.findByUsername(springSecurityService.getPrincipal().username)

        person.privacyPolicy = LinkPrivacyPolicy.valueOf(params.privacy)
        person.save(flush: true)

        render this.success("saved")
    }
}
