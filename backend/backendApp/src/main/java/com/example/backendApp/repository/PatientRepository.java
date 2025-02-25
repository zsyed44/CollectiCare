package com.example.backendApp.repository;

import com.example.backendApp.config.DBConfig;
import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.Patient;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Optional;

@Repository
public class PatientRepository {
private final DBConfig dbConfig;

public PatientRepository(DBConfig dbConfig) {
    this.dbConfig = dbConfig;
}

/**
 * Utility method to fetch an active database session and bind it to the current thread.
 */
private ODatabaseSession getDatabaseSessionWithThreadBinding() {
    ODatabaseSession dbSession = dbConfig.getDatabaseSession();
    if (dbSession == null || dbSession.isClosed()) {
        throw new IllegalStateException("❌ Database session is not available.");
    }

    // Bind session to the current thread
    ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
    return dbSession;
}

/**
 * Retrieve all patients from the database.
 */
public List<Patient> getAllPatients() {
    List<Patient> patients = new ArrayList<>();
    try {
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        var resultSet = dbSession.query("SELECT * FROM Patient");

        while (resultSet.hasNext()) {
            var result = resultSet.next();
            if (result.getRecord().isPresent()) {
                ODocument doc = (ODocument) result.getRecord().get();
                patients.add(mapToPatient(doc));
            }
        }
    } catch (Exception e) {
        System.err.println("❌ Error retrieving patients: " + e.getMessage());
    }
    return patients;
}

/**
 * Retrieve a specific patient by ID.
 */
public Optional<Patient> getPatientById(String patientID) {
    try {
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        var resultSet = dbSession.query("SELECT FROM Patient WHERE PatientID = ?", patientID);
        if (resultSet.hasNext()) {
            var result = resultSet.next();
            if (result.getRecord().isPresent()) {
                return Optional.of(mapToPatient((ODocument) result.getRecord().get()));
            }
        }
    } catch (Exception e) {
        System.err.println("❌ Error retrieving patient by ID: " + e.getMessage());
    }
    return Optional.empty();
}

/**
 * Retrieve a specific patient by ID & Camp Address.
 */
public Optional<Patient> getPatientByIdAndAddress(String patientID, String address) {
    try {
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        var resultSet = dbSession.query("SELECT FROM Patient WHERE PatientID = ? AND Address = ?", patientID, address);
        if (resultSet.hasNext()) {
            var result = resultSet.next();
            if (result.getRecord().isPresent()) {
                return Optional.of(mapToPatient((ODocument) result.getRecord().get()));
            }
        }
    } catch (Exception e) {
        System.err.println("❌ Error retrieving patient by ID: " + e.getMessage());
    }
    return Optional.empty();
}

/**
 * Add a new patient to the database.
 */
public boolean addPatient(Patient patient) {
    try {
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        dbSession.begin(); // Start transaction

        ODocument doc = new ODocument("Patient");
        doc.field("PatientID", patient.getPatientID());
        doc.field("Name", patient.getName());
        doc.field("DOB", patient.getDob());
        doc.field("GIS_Location", patient.getGisLocation());
        doc.field("Govt_ID", patient.getGovtID());
        doc.field("ContactInfo", patient.getContactInfo());
        doc.field("ConsentForFacialRecognition", patient.isConsentForFacialRecognition());
        doc.field("Phone", patient.getPhone());
        doc.field("Address", patient.getAddress());
        doc.field("EyeStatus", patient.getEyeStatus());
        doc.field("Gender", patient.getGender());

        doc.save(); // Save the document
        dbSession.commit(); // Commit transaction

        return true; // Return success
    } catch (Exception e) {
        System.err.println("❌ Error adding patient: " + e.getMessage());
    }
    return false;
}


/**
 * Delete a patient by ID.
 */
public boolean deletePatient(String patientID) {
    try {
        ODatabaseSession dbSession = getDatabaseSessionWithThreadBinding();
        dbSession.begin(); // Start transaction
        int deletedRecords = dbSession.command("DELETE VERTEX Patient WHERE PatientID = ?", patientID).next().getProperty("count");
        dbSession.commit(); // Commit transaction

        return deletedRecords > 0; // Return true if any record was deleted
    } catch (Exception e) {
        System.err.println("❌ Error deleting patient: " + e.getMessage());
    }
    return false;
}

/**
 * Maps an `ODocument` to a `Patient` object.
 */
private Patient mapToPatient(ODocument doc) {
    return new Patient(
            doc.field("PatientID", String.class),
            doc.field("Name", String.class),
            doc.field("DOB", Date.class),
            doc.field("GIS_Location", String.class),
            doc.field("Govt_ID", String.class),
            doc.field("ContactInfo", String.class),
            doc.field("ConsentForFacialRecognition", Boolean.class),
            doc.field("Phone", String.class),
            doc.field("Address", String.class),
            doc.field("EyeStatus", String.class),
            doc.field("Gender", String.class)
    );
}
}
