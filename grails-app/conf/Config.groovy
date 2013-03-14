// locations to search for config files that get merged into the main config;
// config files can be ConfigSlurper scripts, Java properties files, or classes
// in the classpath in ConfigSlurper format

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if (System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }

grails.project.groupId = appName // change this to alter the default package name and Maven publishing destination
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [
    all:           '*/*',
    atom:          'application/atom+xml',
    css:           'text/css',
    csv:           'text/csv',
    form:          'application/x-www-form-urlencoded',
    html:          ['text/html','application/xhtml+xml'],
    js:            'text/javascript',
    json:          ['application/json', 'text/json'],
    multipartForm: 'multipart/form-data',
    rss:           'application/rss+xml',
    text:          'text/plain',
    xml:           ['text/xml', 'application/xml']
]

// URL Mapping Cache Max Size, defaults to 5000
//grails.urlmapping.cache.maxsize = 1000

// What URL patterns should be processed by the resources plugin
grails.resources.adhoc.patterns = ['/images/*', '/css/*', '/js/*', '/plugins/*']

// The default codec used to encode data with ${}
grails.views.default.codec = "none" // none, html, base64
grails.views.gsp.encoding = "UTF-8"
grails.converters.encoding = "UTF-8"
// enable Sitemesh preprocessing of GSP pages
grails.views.gsp.sitemesh.preprocess = true
// scaffolding templates configuration
grails.scaffolding.templates.domainSuffix = 'Instance'

// Set to false to use the new Grails 1.2 JSONBuilder in the render method
grails.json.legacy.builder = false
// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true
// packages to include in Spring bean scanning
grails.spring.bean.packages = []
// whether to disable processing of multi part requests
grails.web.disable.multipart=false

// request parameters to mask when logging exceptions
grails.exceptionresolver.params.exclude = ['password']

// configure auto-caching of queries by default (if false you can cache individual queries with 'cache: true')
grails.hibernate.cache.queries = false

environments {
    development {
        grails.logging.jul.usebridge = true

        grails.plugins.springsecurity.mock.active = true
        grails.plugins.springsecurity.mock.fullName = "Alexis PARIS"
        grails.plugins.springsecurity.mock.email = "alexis.rt.paris@gmail.com"
        grails.plugins.springsecurity.mock.username =  "paris_alex"
        grails.plugins.springsecurity.mock.roles = [ 'ROLE_USER', 'ROLE_TWITTER', 'ROLE_ADMIN' ]
        grails.plugins.springsecurity.ipRestrictions = [ '/**': ['127.0.0.0/8', '::1/128'] ]
    }
    test {
        grails.logging.jul.usebridge = true

        grails.plugins.springsecurity.mock.active = true
        grails.plugins.springsecurity.mock.fullName = "Alexis PARIS"
        grails.plugins.springsecurity.mock.email = "alexis.rt.paris@gmail.com"
        grails.plugins.springsecurity.mock.username =  "paris_alex"
        grails.plugins.springsecurity.mock.roles = [ 'ROLE_USER', 'ROLE_TWITTER']
        grails.plugins.springsecurity.ipRestrictions = [ '/**': ['127.0.0.0/8', '::1/128'] ]
    }
    production {
        grails.logging.jul.usebridge = false
        // TODO: grails.serverURL = "http://www.changeme.com"

        grails.plugins.springsecurity.mock.active = false
    }
}

// log4j configuration
log4j = {
    // Example of changing the log pattern for the default console appender:
    //
    //appenders {
    //    console name:'stdout', layout:pattern(conversionPattern: '%c{2} %m%n')
    //}

    debug "grails.app.controllers.linkguardian.LinkController",
          "grails.app.controllers.linkguardian.PersonController",
          "grails.app.services.linkguardian.LinkBuilderService",
          "grails.app.services.linkguardian.StringNormalizerService"/*,
          'org.hibernate.SQL',
          'org.hibernate.transaction'*/

    //debug "grails.app"

    error  'org.codehaus.groovy.grails.web.servlet',        // controllers
           'org.codehaus.groovy.grails.web.pages',          // GSP
           'org.codehaus.groovy.grails.web.sitemesh',       // layouts
           'org.codehaus.groovy.grails.web.mapping.filter', // URL mapping
           'org.codehaus.groovy.grails.web.mapping',        // URL mapping
           'org.codehaus.groovy.grails.commons',            // core / classloading
           'org.codehaus.groovy.grails.plugins',            // plugins
           'org.codehaus.groovy.grails.orm.hibernate',      // hibernate integration
           'org.springframework',
           'org.hibernate',
           'net.sf.ehcache.hibernate'
}

google.analytics.webPropertyID = "UA-29683223-2"

// Added by the Spring Security Core plugin:
grails.plugins.springsecurity.userLookup.userDomainClassName = 'linkguardian.Person'
grails.plugins.springsecurity.userLookup.authorityJoinClassName = 'linkguardian.PersonRole'
grails.plugins.springsecurity.authority.className = 'linkguardian.Role'


grails.plugins.springsecurity.twitter.app.key='dRDPZlccjxpnkyCPAPjtg'
grails.plugins.springsecurity.twitter.app.consumerKey='dRDPZlccjxpnkyCPAPjtg'
grails.plugins.springsecurity.twitter.app.consumerSecret='0BM06vBD436nPxZ41mLgthokfvdXj0HUbxrK3iP8'

security {
    twitter {
        app {
            id = "dRDPZlccjxpnkyCPAPjtg"
            key = "dRDPZlccjxpnkyCPAPjtg"
            consumerKey = "dRDPZlccjxpnkyCPAPjtg"
            consumerSecret = "0BM06vBD436nPxZ41mLgthokfvdXj0HUbxrK3iP8"
        }
        language = "en_US"
        button.text = "Login with Twitter"
        popup = false

        autoCreate {
            active = true
            roles = ["ROLE_USER", "ROLE_TWITTER"]
        }

        filter {
            processUrl = "/j_spring_twitter_security_check"
            processPopupUrl = "/twitterAuth/popup"
        }

        domain {
            classname = "TwitterUser"
            connectionPropertyName = "user"
        }
    }
}

google.shortener.api.key='AIzaSyCngRB7vyyCtY4B1ACOYyUt5pDEtLnhkzo'
//grails.plugins.springsecurity.twitter.bean.dao='linkguardian.LgTwitterAuthDao'

contact.mail='linkguardian@blackdog-project.org'