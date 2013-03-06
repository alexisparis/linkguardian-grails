
/*
PostgreSQL 8.4 database added.  Please make note of these credentials:

   Root Person: admin
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
    cache.use_query_cache = true
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
            dbCreate = "create-drop"//"create-drop"//"update"
            url = "jdbc:postgresql://127.5.32.1:5432/linkguardianIntegrationTest"
            username = "admin"
            password = "PFbIHZJ_WumX"
            driverClassName = "org.postgresql.Driver"
            dialect = org.hibernate.dialect.PostgreSQLDialect
        }
    }
    production {
        dataSource {
            dbCreate = "create-drop"//"create-drop"//"update"
            url = "jdbc:postgresql://127.6.232.1:5432/linkguardian"
            username = "admin"
            password = "pHCHSMI4qQ_y"
            driverClassName = "org.postgresql.Driver"
            dialect = org.hibernate.dialect.PostgreSQLDialect
        }
    }
}
