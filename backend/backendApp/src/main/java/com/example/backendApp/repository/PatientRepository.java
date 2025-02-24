package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.example.backendApp.model.Patient;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@Repository
public class PatientRepository {
    private final ODatabaseSession dbSession;

    public PatientRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    public void savePatient(Patient patient) {
        try {
            ODocument doc = new ODocument("Patient");
            doc.field("PatientID", patient.getPatientID());
            doc.field("Name", patient.getName());
            doc.field("DOB", patient.getDob());
            doc.field("GIS_Location", patient.getGisLocation());
            doc.field("Govt_ID", patient.getGovtID());
            doc.field("ContactInfo", patient.getContactInfo());
            doc.field("ConsentForFacialRecognition", patient.isConsentForFacialRecognition());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        var resultSet = dbSession.query("SELECT * FROM Patient");

        while (resultSet.hasNext()) {
            var result = resultSet.next();
            if (result.getRecord().isPresent()) {
                ODocument doc = (ODocument) result.getRecord().get();
                patients.add(new Patient(
                        doc.field("PatientID", String.class),
                        doc.field("Name", String.class),
                        doc.field("DOB", Date.class),
                        doc.field("GIS_Location", String.class),
                        doc.field("Govt_ID", String.class),
                        doc.field("ContactInfo", String.class),
                        doc.field("ConsentForFacialRecognition", Boolean.class)
                ));
            }
        }
        return patients;
    }

    public void deletePatient(String patientID) {
        dbSession.command("DELETE VERTEX Patient WHERE PatientID = ?", patientID);
    }
}
