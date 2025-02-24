package com.example.backendApp.repository;

import com.orientechnologies.orient.core.db.ODatabaseDocumentInternal;
import com.orientechnologies.orient.core.db.ODatabaseRecordThreadLocal;
import com.orientechnologies.orient.core.db.ODatabaseSession;
import com.orientechnologies.orient.core.record.ORecord;
import com.orientechnologies.orient.core.record.impl.ODocument;
import com.example.backendApp.model.Appointment;
import org.springframework.stereotype.Repository;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.ArrayList;
import java.util.Date;

@Repository
public class AppointmentRepository {

    private final ODatabaseSession dbSession;
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public AppointmentRepository(ODatabaseSession dbSession) {
        this.dbSession = dbSession;
    }

    //  Save Appointment (Node)
    public void saveAppointment(Appointment appointment) {
        try {
            ensureActiveSession();
            ODocument doc = new ODocument("Appointment");
            doc.field("AppointmentID", appointment.getAppointmentID());
            doc.field("DateTime", dateFormat.format(appointment.getDateTime())); // Convert Date to String
            doc.field("Status", appointment.getStatus());
            doc.field("patientID", appointment.getPatientID());
            doc.save();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get All Appointments (Nodes)
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();

        try {
            ensureActiveSession();
            var resultSet = dbSession.query("SELECT * FROM Appointment");

            while (resultSet.hasNext()) {
                var result = resultSet.next();
                if (result.getRecord().isPresent()) {
                    ORecord record = result.getRecord().get();
                    if (record instanceof ODocument doc) {
                        String appointmentID = doc.field("AppointmentID", String.class);
                        String dateTimeStr = doc.field("DateTime", String.class);
                        String status = doc.field("Status", String.class);
                        String patientID = doc.field("patientID", String.class);

                        Date dateTime = (dateTimeStr != null) ? dateFormat.parse(dateTimeStr) : null;
                        appointments.add(new Appointment(appointmentID, dateTime, status, patientID));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    // Delete an Appointment
    public void deleteAppointment(String appointmentID) {
        try {
            ensureActiveSession();
            dbSession.command("DELETE VERTEX Appointment WHERE AppointmentID = ?", appointmentID);
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
