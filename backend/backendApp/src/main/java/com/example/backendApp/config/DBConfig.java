package com.example.backendApp.config;

import com.orientechnologies.orient.core.db.*;
import com.orientechnologies.orient.core.metadata.schema.OSchema;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DBConfig {

    private static final String DB_NAME = "MedicalService";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Kwaku";
    private static final String ORIENTDB_HOST = "remote:172.30.107.87";

    private OrientDB orientDB;
    private ODatabaseSession dbSession;

    @PostConstruct
    public void init() {
        this.orientDB = new OrientDB(ORIENTDB_HOST, OrientDBConfig.defaultConfig());
        this.dbSession = orientDB.open(DB_NAME, DB_USER, DB_PASSWORD);

        if (dbSession == null || dbSession.isClosed()) {
            throw new RuntimeException("Failed to connect to OrientDB!");
        }

        System.out.println("Successfully connected to OrientDB: " + DB_NAME);
        initDatabaseSchema();
    }

    @Bean
    public ODatabaseSession getDatabaseSession() {
        if (dbSession == null || dbSession.isClosed()) {
            this.dbSession = orientDB.open(DB_NAME, DB_USER, DB_PASSWORD);
        }
        return this.dbSession;
    }

    @PreDestroy
    public void closeDatabaseSession() {
        try {
            if (dbSession != null && !dbSession.isClosed()) {
                dbSession.activateOnCurrentThread();
                dbSession.close();
                System.out.println("Database session closed.");
            }
        } catch (Exception e) {
            System.err.println("Error closing database session: " + e.getMessage());
        }

        try {
            if (orientDB != null) {
                orientDB.close();
                System.out.println("OrientDB connection closed.");
            }
        } catch (Exception e) {
            System.err.println("Error closing OrientDB: " + e.getMessage());
        }
    }

    private void initDatabaseSchema() {
        try (ODatabaseSession db = orientDB.open(DB_NAME, DB_USER, DB_PASSWORD)) {
            OSchema schema = db.getMetadata().getSchema();
            System.out.println("Database schema initialized.");
        } catch (Exception e) {
            System.err.println("Failed to initialize schema: " + e.getMessage());
        }
    }
}
