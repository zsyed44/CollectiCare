package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.CampWorker;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.ArrayList;

@Repository
public class CampWorkerRepository {

    private final ODatabaseSession dbSession;

    public CampWorkerRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    // ✅ Save a Camp Worker (as a node)
    public void saveCampWorker(CampWorker worker) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("CampWorker");
            doc.field("WorkerID", worker.getWorkerID());
            doc.field("Name", worker.getName());
            doc.field("Role", worker.getRole());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Get All Camp Workers (Nodes Query)
    public List<CampWorker> getAllCampWorkers() {
        List<CampWorker> workers = new ArrayList<>();

        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM CampWorker");

            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String workerID = doc.field("WorkerID", String.class);
                        String name = doc.field("Name", String.class);
                        String role = doc.field("Role", String.class);

                        workers.add(new CampWorker(workerID, name, role));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return workers;
    }

    // ✅ Assign Camp Worker to a Camp (Graph Edge)
    public void linkWorkerToCamp(String workerID, String campID) {
        try {
            ensureActiveSession();
            String query = String.format(
                    "CREATE EDGE ASSIGNED_TO FROM (SELECT FROM CampWorker WHERE WorkerID='%s') TO (SELECT FROM Camp WHERE CampID='%s')",
                    workerID, campID);
            dbSession.command(query);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ✅ Delete a Camp Worker
    public void deleteCampWorker(String workerID) {
        try {
            ensureActiveSession();
            dbSession.command("DELETE VERTEX CampWorker WHERE WorkerID = ?", workerID);
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
