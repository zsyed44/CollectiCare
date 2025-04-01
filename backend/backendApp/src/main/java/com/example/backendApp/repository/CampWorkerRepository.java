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
            doc.field("Password", worker.getPassword());
            doc.field("Location",worker.getLocation());
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
                        String password = doc.field("Password", String.class);
                        String location = doc.field("Location", String.class);

                        workers.add(new CampWorker(workerID, name, role, password, location));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return workers;
    }

    // ✅ Get a Camp Worker by WorkerID
    public CampWorker getCampWorkerByWorkerID(String workerID) {
        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM CampWorker WHERE WorkerID = ?", workerID);

            if (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String name = doc.field("Name", String.class);
                        String role = doc.field("Role", String.class);
                        String password = doc.field("Password", String.class);
                        String location = doc.field("Location", String.class);

                        return new CampWorker(workerID, name, role, password, location);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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

    public void updateWorkerLocation(String workerID, String location) {
        try {
            ensureActiveSession();

            // Update the worker's location using an update query
            String query = String.format(
                    "UPDATE CampWorker SET Location = '%s' WHERE WorkerID = '%s'", location, workerID);

            // Execute the update command
            dbSession.command(query);
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
