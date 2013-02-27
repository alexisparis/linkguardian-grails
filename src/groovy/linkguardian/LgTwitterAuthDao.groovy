package linkguardian

import com.the6hours.grails.springsecurity.twitter.DefaultConnectedTwitterAuthDao
import com.the6hours.grails.springsecurity.twitter.TwitterAuthToken

/**
 * Created with IntelliJ IDEA.
 * User: alexis
 * Date: 27/02/13
 * Time: 14:12
 * To change this template use File | Settings | File Templates.
 */
class LgTwitterAuthDao extends DefaultConnectedTwitterAuthDao
{


    Object createAppUser(TwitterAuthToken token) {

        println "#######################"
        println "calling create app user"
        println "#######################"

        //TODO wtf???
        def conf = SpringSecurityUtils.securityConfig
        Class<?> MainUser = grailsApplication.getDomainClass(userDomainClassName).clazz
        def user = MainUser.newInstance()
        user.password = token.token
        user.username = token.screenName
        MainUser.withTransaction { status ->
            user.save()
        }
        conf.twitter.autoCreate.roles.collect {
            Class<?> Role = grailsApplication.getDomainClass(conf.authority.className).clazz
            def role = Role.findByAuthority(it)
            if (!role) {
                role = Role.newInstance()
                role.properties[conf.authority.nameField] = it
                Role.withTransaction { status ->
                    role.save()
                }
            }
            return role
        }.each { role ->
            Class<?> PersonRole = grailsApplication.getDomainClass(conf.userLookup.authorityJoinClassName).clazz
            PersonRole.withTransaction { status ->
                PersonRole.create(user, role, false)
            }
        }
        return user
    }
}
