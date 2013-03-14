
/*
PostgreSQL 8.4 database added.  Please make note of these credentials:

   Root Person: admin
   Root Password: ClWkVQ5B_Ay6
   Database Name: linkguardian

Connection URL: postgresql://$OPENSHIFT_POSTGRESQL_DB_HOST:$OPENSHIFT_POSTGRESQL_DB_PORT/
 */



/*dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}*/
hibernate {
    cache.use_second_level_cache = false
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
            dbCreate = "create-drop"//"update"
            url = "jdbc:postgresql://127.4.197.1:5432/linkguardianTest"
            username = "admin"
            password = "ldEAHlVMk13d"
            driverClassName = "org.postgresql.Driver"
            dialect = org.hibernate.dialect.PostgreSQLDialect
        }
    }
    production {
        dataSource {
            dbCreate = "update"

            // openshift
            url = "jdbc:postgresql://127.2.98.1:5432/linkguardian"
            username = "admin"
            password = "tEmNIv7xfwlL"

            // heroku
            //url = "jdbc:postgresql://ec2-23-21-204-86.compute-1.amazonaws.com:5432/dalt15otdi6uot"
            //username = "axkummniocergu"
            //password = "ENR24IfseFkt5ayVB2emg6_URv"

            driverClassName = "org.postgresql.Driver"
            dialect = org.hibernate.dialect.PostgreSQLDialect
        }
    }
}
