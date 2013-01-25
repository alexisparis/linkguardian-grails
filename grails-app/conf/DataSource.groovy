
/*
PostgreSQL 8.4 database added.  Please make note of these credentials:

   Root User: admin
   Root Password: ClWkVQ5B_Ay6
   Database Name: linkguardian

Connection URL: postgresql://$OPENSHIFT_POSTGRESQL_DB_HOST:$OPENSHIFT_POSTGRESQL_DB_PORT/
 */



dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
            url = "jdbc:h2:mem:devDb;MVCC=TRUE;LOCK_TIMEOUT=10000"
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb;MVCC=TRUE;LOCK_TIMEOUT=10000"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://$OPENSHIFT_POSTGRESQL_DB_HOST:$OPENSHIFT_POSTGRESQL_DB_PORT/"
            username = "admin"
            password = "ClWkVQ5B_Ay6"
            driverClassName = "org.postgresql.Driver"
            dialect = org.hibernate.dialect.PostgreSQLDialect
        }
    }
}
