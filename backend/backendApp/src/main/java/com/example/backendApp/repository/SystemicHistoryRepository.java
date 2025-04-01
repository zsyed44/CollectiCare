package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.SystemicHistory;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.ArrayList;

@Repository
public class SystemicHistoryRepository {

    private final ODatabaseSession dbSession;

    public SystemicHistoryRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    // Save Systemic History (Node)
    public boolean saveSystemicHistory(SystemicHistory history) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("SystemicHistory");
            doc.field("patientID", history.getPatientID());
            doc.field("HTN", history.isHTN());
            doc.field("DM", history.isDM());
            doc.field("heartDisease", history.isHeartDisease());
            doc.save();
            return true; // Return success
        } catch (Exception e) {
            System.err.println("❌ Error adding history: " + e.getMessage());
        }
        return false;
    }

    // Get All Systemic History (Nodes)
    public List<SystemicHistory> getAllSystemicHistory() {
        List<SystemicHistory> historyList = new ArrayList<>();

        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM SystemicHistory");

            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String patientID = doc.field("patientID", String.class);
                        boolean HTN = doc.field("HTN", Boolean.class);
                        boolean DM = doc.field("DM", Boolean.class);
                        boolean heartDisease = doc.field("heartDisease", Boolean.class);

                        historyList.add(new SystemicHistory(patientID, HTN, DM, heartDisease));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return historyList;
    }

    // Link Systemic History to Patient (Graph Edge)
    public void linkSystemicHistoryToPatient(String patientID, String historyID) {
        try {
            ensureActiveSession();
            String query = String.format(
                    "CREATE EDGE HAS_SYSTEMIC_HISTORY FROM (SELECT FROM Patient WHERE patientID='%s') TO (SELECT FROM SystemicHistory WHERE @rid='%s')",
                    patientID, historyID);
            dbSession.command(query);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Delete a Systemic History record
    public void deleteSystemicHistory(String historyID) {
        try {
            ensureActiveSession();
            dbSession.command("DELETE VERTEX SystemicHistory WHERE @rid = ?", historyID);
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
