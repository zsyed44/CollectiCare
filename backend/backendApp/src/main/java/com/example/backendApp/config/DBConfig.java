package com.example.backendApp.config;

import com.orientechnologies.orient.core.metadata.schema.OSchema;
import com.orientechnologies.orient.core.db.*;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DBConfig {
    private static final String DB_NAME = "MedicalService";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Obaid";
    private static final String ORIENTDB_HOST = "remote:10.0.0.6";
// remote:34.28.186.106:2424
    //	34.28.186.106
//    private static final String DB_NAME = System.getenv("ORIENTDB_DB");
//    private static final String DB_USER = System.getenv("ORIENTDB_USER");
//    private static final String DB_PASSWORD = System.getenv("ORIENTDB_PASSWORD");
//    private static final String ORIENTDB_HOST = "remote:" + System.getenv("ORIENTDB_HOST") + ":2424";


    private OrientDB orientDB;
    private ODatabaseSession dbSession;

    @PostConstruct
    public void init() {
        try {
            this.orientDB = new OrientDB(ORIENTDB_HOST, OrientDBConfig.defaultConfig());
            this.dbSession = orientDB.open(DB_NAME, DB_USER, DB_PASSWORD);
            if (dbSession == null || dbSession.isClosed()) {
                throw new RuntimeException("❌ Failed to connect to OrientDB!");
            }

            // Ensure session is available
            ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
            System.out.println("✅ Successfully connected to OrientDB: " + DB_NAME);
        } catch (Exception e) {
            System.err.println("❌ Error initializing OrientDB: " + e.getMessage());
            throw new RuntimeException("Failed to initialize OrientDB", e);
        }
    }

    @Bean
    public synchronized ODatabaseSession getDatabaseSession() {
        try {
            if (dbSession == null || dbSession.isClosed()) {
                System.out.println("⚠️ Reconnecting to OrientDB...");
                this.dbSession = orientDB.open(DB_NAME, DB_USER, DB_PASSWORD);
            }
            ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
            return this.dbSession;
        } catch (Exception e) {
            System.err.println("❌ Error opening database session: " + e.getMessage());
            throw new RuntimeException("Database connection failure", e);
        }
    }

    @PreDestroy
    public void closeDatabaseSession() {
        try {
            if (dbSession != null && !dbSession.isClosed()) {
                dbSession.activateOnCurrentThread();
                dbSession.close();
                System.out.println("✅ Database session closed.");
            }
        } catch (Exception e) {
            System.err.println("❌ Error closing database session: " + e.getMessage());
        }

        try {
            if (orientDB != null) {
                orientDB.close();
                System.out.println("✅ OrientDB connection closed.");
            }
        } catch (Exception e) {
            System.err.println("❌ Error closing OrientDB: " + e.getMessage());
        }
    }
}
