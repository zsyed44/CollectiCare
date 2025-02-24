package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.AllergyHistory;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.ArrayList;

@Repository
public class AllergyHistoryRepository {

    private final ODatabaseSession dbSession;

    public AllergyHistoryRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    // Save Allergy History (Node)
    public void saveAllergyHistory(AllergyHistory history) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("AllergyHistory");
            doc.field("patientID", history.getPatientID());
            doc.field("allergyDrops", history.isAllergyDrops());
            doc.field("allergyTablets", history.isAllergyTablets());
            doc.field("seasonalAllergies", history.isSeasonalAllergies());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get All Allergy History (Nodes)
    public List<AllergyHistory> getAllAllergyHistory() {
        List<AllergyHistory> historyList = new ArrayList<>();

        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM AllergyHistory");

            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String patientID = doc.field("patientID", String.class);
                        boolean allergyDrops = doc.field("allergyDrops", Boolean.class);
                        boolean allergyTablets = doc.field("allergyTablets", Boolean.class);
                        boolean seasonalAllergies = doc.field("seasonalAllergies", Boolean.class);

                        historyList.add(new AllergyHistory(patientID, allergyDrops, allergyTablets, seasonalAllergies));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historyList;
    }

    // Link Allergy History to Patient (Graph Edge)
    public void linkAllergyHistoryToPatient(String patientID, String historyID) {
        try {
            ensureActiveSession();
            String query = String.format(
                    "CREATE EDGE HAS_ALLERGY_HISTORY FROM (SELECT FROM Patient WHERE patientID='%s') TO (SELECT FROM AllergyHistory WHERE @rid='%s')",
                    patientID, historyID);
            dbSession.command(query);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete an Allergy History record
    public void deleteAllergyHistory(String historyID) {
        try {
            ensureActiveSession();
            dbSession.command("DELETE VERTEX AllergyHistory WHERE @rid = ?", historyID);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void ensureActiveSession() {
        if (dbSession == null || dbSession.isClosed()) {
            throw new IllegalStateException("Database session is not active.");
        }
        ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
    }
}
