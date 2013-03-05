package linkguardian

import grails.converters.JSON
import grails.plugins.springsecurity.Secured
import org.springframework.web.servlet.ModelAndView

@Secured(['ROLE_USER'])
class PersonController extends MessageOrientedObject
{
    def springSecurityService

    def personsPerPage = 100

    def saveConfiguration()
    {
        log.info "calling saveConfiguration with privacy : " + params.privacy

        def person = Person.findByUsername(springSecurityService.getPrincipal().username)

        person.privacyPolicy = LinkPrivacyPolicy.valueOf(params.privacy)
        person.save(flush: true)

        render this.success("saved") as JSON
    }

    def persons(String username, String format, int page)
    {
        log.info "calling searchPersons with username : " + username + " with format : " + format + " on page " + page

        def results = [] // list of PersonResult

        def formatJson = 'json' == format
        def _page = page
        if ( _page < 1 )
        {
            _page = 1
        }

        def connectedUser = Person.findByUsername(springSecurityService.principal.username)

        def _username = username
        if ( _username == null )
            _username = ""

        def queryParams = [max: personsPerPage, offset: (_page - 1) * personsPerPage]//, sort: _sortBy, order: _sortType]

        def q = Person.createCriteria()

        if ( formatJson )
        {
            def iterator = q.list(queryParams) {
                and
                {
                    ilike('username', "%" + _username + "%")
                    not {
                        eq('privacyPolicy', LinkPrivacyPolicy.ALL_LOCKED) //not user whose links are private
                    }
                    not {
                        eq('username', springSecurityService.principal.username)  // not connected user
                    }
                }
                projections {
                    property('username')
                }
            }

            iterator.each {
                results.add(new PersonResult(username : it))
            }
        }
        else
        {
            def iterator = q.list(queryParams) {
                and
                {
                    ilike('username', "%" + _username + "%")
                    not {
                        eq('privacyPolicy', LinkPrivacyPolicy.ALL_LOCKED) //not user whose links are private
                    }
                    not {
                        eq('username', springSecurityService.principal.username)  // not connected user
                    }
                }
            }

            iterator.each {
                results.add(new PersonResult(username : it.username, linksCount: it.links.size()))
            }
        }

        log.info "results found ==> " + results.size()

        // sort result
        results.sort {
            a, b ->
                if ( username == a.username )
                {
                    -1
                }
                else if ( username == b.username )
                {
                    1
                }
                else
                {
                    a.username <=> b.username
                }
        }

        if ( results.isEmpty() )
        {
            response.status = 404
        }
        else
        {
            if ( formatJson )
            {
                render results as JSON
            }
            else
            {
                return new ModelAndView("/person/persons", [persons : results, username:  username, policy : connectedUser.privacyPolicy])
            }
        }
    }
}
