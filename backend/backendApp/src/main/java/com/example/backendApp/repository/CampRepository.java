package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.Camp;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.ArrayList;

@Repository
public class CampRepository {

    private final ODatabaseSession dbSession;

    public CampRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    // Save Camp (Node)
    public void saveCamp(Camp camp) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("Camp");
            doc.field("CampID", camp.getCampID());
            doc.field("Location", camp.getLocation());
            doc.field("GIS_Coordinates", camp.getGisCoordinates());
            doc.field("TotalPatients", camp.getTotalPatients());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get All Camps (Nodes)
    public List<Camp> getAllCamps() {
        List<Camp> camps = new ArrayList<>();

        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM Camp");

            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String campID = doc.field("CampID", String.class);
                        String location = doc.field("Location", String.class);
                        String coordinates = doc.field("GIS_Coordinates", String.class);
                        Integer totalPatients = doc.field("TotalPatients", Integer.class);

                        camps.add(new Camp(campID, location, coordinates, totalPatients));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return camps;
    }

    // Delete a Camp
    public void deleteCamp(String campID) {
        try {
            ensureActiveSession();
            dbSession.command("DELETE VERTEX Camp WHERE CampID = ?", campID);
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
