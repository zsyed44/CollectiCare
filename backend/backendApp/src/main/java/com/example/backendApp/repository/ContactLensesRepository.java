package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.ContactLensesHistory;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.ArrayList;

@Repository
public class ContactLensesRepository {

    private final ODatabaseSession dbSession;

    public ContactLensesRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    // Save Systemic History (Node)
    public boolean saveContactLensesHistory(ContactLensesHistory history) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("ContactLensesHistory");
            doc.field("patientID", history.getPatientID());
            doc.field("frequency", history.isFrequency());
            doc.field("usesContactLenses", history.isUsesContactLenses());
            doc.field("yearsOfUse", history.isyearsOfUse());
            doc.save();
            return true; // Return success
        } catch (Exception e) {
            System.err.println("❌ Error adding history: " + e.getMessage());
        }
        return false;
    }

    private void ensureActiveSession() {
        if (dbSession == null || dbSession.isClosed()) {
            throw new IllegalStateException("Database session is not active.");
        }
        ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
    }
}