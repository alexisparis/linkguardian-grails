package linkguardian.crud

import grails.plugins.springsecurity.Secured
import linkguardian.Person

@Secured(['ROLE_ADMIN'])
class UserController
{
    static scaffold = Person
}
