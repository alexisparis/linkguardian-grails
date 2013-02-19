package linkguardian.crud

import grails.plugins.springsecurity.Secured
import linkguardian.Role

@Secured(['ROLE_ADMIN'])
class RoleCrudController
{
    static scaffold = Role
}
