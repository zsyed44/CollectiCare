package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import org.springframework.boot.autoconfigure.security.SecurityProperties.User;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.example.backendApp.model.Patient;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;


//THIS WILL BE USED TO CONNECT TO THE DATABASE
@Repository
public class PatientRepository {

    private final ODatabaseSession dbSession;

    public PatientRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    public void savePatient(Patient patient) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("Patient");
            doc.field("Name", patient.getName());
            doc.field("Age", patient.getAge());
            doc.field("CampID", patient.getCampID());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();

        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM Patient");

            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String name = doc.field("Name", String.class);
                        Integer age = doc.field("Age", Integer.class);
                        Integer campID = doc.field("CampID", Integer.class);

                        // Handle possible null values with default values
                        name = (name != null) ? name : "Unknown";
                        age = (age != null) ? age : 0;
                        campID = (campID != null) ? campID : -1; // i added a space in the field name :3, so doesn't work

                        patients.add(new Patient(name, age, campID));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return patients;
    }


    private void ensureActiveSession() {
        if (dbSession == null || dbSession.isClosed()) {
            throw new IllegalStateException("Database session is not active.");
        }
        ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
    }
}
