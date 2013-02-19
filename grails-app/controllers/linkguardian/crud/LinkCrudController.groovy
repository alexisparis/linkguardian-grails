package linkguardian.crud

import grails.plugins.springsecurity.Secured
import linkguardian.Link

@Secured(['ROLE_ADMIN'])
class LinkCrudController
{
    static scaffold = Link
}
