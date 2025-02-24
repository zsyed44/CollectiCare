package com.example.backendApp.repository;

import com.example.backendApp.model.OphthalmologyHistory;
import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import org.springframework.stereotype.Repository;
import java.util.ArrayList;
import java.util.List;

@Repository
public class OphthalmologyHistoryRepository {

    private final ODatabaseSession dbSession;

    public OphthalmologyHistoryRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    public void saveOphthalmologyHistory(OphthalmologyHistory history) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("OphthalmologyHistory");
            doc.field("patientID", history.getPatientID());
            doc.field("lossOfVision", history.isLossOfVision());
            doc.field("lossOfVisionEye", history.getLossOfVisionEye());
            doc.field("lossOfVisionOnset", history.getLossOfVisionOnset());
            doc.field("lossOfVisionPain", history.isLossOfVisionPain());
            doc.field("lossOfVisionDuration", history.getLossOfVisionDuration());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<OphthalmologyHistory> getAllHistories() {
        List<OphthalmologyHistory> histories = new ArrayList<>();
        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM OphthalmologyHistory");
            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        histories.add(new OphthalmologyHistory(
                                doc.field("patientID", String.class),
                                doc.field("lossOfVision", Boolean.class),
                                doc.field("lossOfVisionEye", String.class),
                                doc.field("lossOfVisionOnset", String.class),
                                doc.field("lossOfVisionPain", Boolean.class),
                                doc.field("lossOfVisionDuration", String.class),
                                doc.field("rednessOnset", String.class),
                                doc.field("painEye", String.class),
                                doc.field("pain", Boolean.class),
                                doc.field("rednessPain", Boolean.class),
                                doc.field("wateringEye", String.class),
                                doc.field("painDuration", String.class)
                        ));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return histories;
    }

    private void ensureActiveSession() {
        if (dbSession == null || dbSession.isClosed()) {
            throw new IllegalStateException("Database session is not active.");
        }
        ODatabaseRecordThreadLocal.instance().set((ODatabaseDocumentInternal) dbSession);
    }
}
