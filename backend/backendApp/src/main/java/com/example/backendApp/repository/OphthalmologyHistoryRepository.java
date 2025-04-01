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

    public boolean saveOphthalmologyHistory(OphthalmologyHistory history) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("OphthalmologyHistory");
            doc.field("patientID", history.getPatientID());
            doc.field("lossOfVision", history.isLossOfVision());
            doc.field("lossOfVisionEye", history.getLossOfVisionEye());
            doc.field("lossOfVisionOnset", history.getLossOfVisionOnset());
            doc.field("lossOfVisionPain", history.isLossOfVisionPain());
            doc.field("lossOfVisionDuration", history.getLossOfVisionDuration());
            doc.field("redness", history.isRedness());
            doc.field("rednessEye", history.getRednessEye());
            doc.field("rednessOnset", history.getRednessOnset());
            doc.field("rednessPain", history.isRednessPain());
            doc.field("rednessDuration", history.getRednessDuration());
            doc.field("wateringEye", history.getWateringEye());
            doc.field("wateringOnset", history.getWateringOnset());
            doc.field("wateringPain", history.isWateringPain());
            doc.field("wateringDuration", history.getWateringDuration());
            doc.field("wateringDischargeType", history.getWateringDischargeType());
            doc.field("itching", history.isItching());
            doc.field("itchingEye", history.getItchingEye());
            doc.field("pain", history.isPain());
            doc.field("painEye", history.getPainEye());
            doc.field("painOnset", history.getPainOnset());
            doc.field("painDuration", history.getPainDuration());

            doc.save();
            return true; // Return success
        } catch (Exception e) {
            System.err.println("❌ Error adding history: " + e.getMessage());
        }
        return false;
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
                                doc.field("redness", Boolean.class),
                                doc.field("rednessEye", String.class),
                                doc.field("rednessOnset", String.class),
                                doc.field("rednessPain", Boolean.class),
                                doc.field("rednessDuration", String.class),
                                doc.field("wateringEye", String.class),
                                doc.field("wateringOnset", String.class),
                                doc.field("wateringPain", Boolean.class),
                                doc.field("wateringDuration", String.class),
                                doc.field("wateringDischargeType", String.class),
                                doc.field("itching", Boolean.class),
                                doc.field("itchingEye", String.class),
                                doc.field("pain", Boolean.class),
                                doc.field("painEye", String.class),
                                doc.field("painOnset", String.class),
                                doc.field("painDuration", String.class)));
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
