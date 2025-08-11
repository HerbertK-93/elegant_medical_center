import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----------- Patients -----------
  Stream<QuerySnapshot> getPatients(String department) {
    return _db
        .collection('patients')
        .where('department', isEqualTo: department)
        .snapshots();
  }

  Future<void> addPatient(
      String name, int age, String contact, String department) async {
    await _db.collection('patients').add({
      'name': name,
      'age': age,
      'contact': contact,
      'department': department,
    });
  }

  Future<void> deletePatient(String patientId) async {
    await _db.collection('patients').doc(patientId).delete();
  }

  // ----------- Appointments -----------
  Stream<QuerySnapshot> getAppointments(String department) {
    return _db
        .collection('appointments')
        .where('department', isEqualTo: department)
        .snapshots();
  }

  Future<void> addAppointment(
      String patientId, DateTime date, String department) async {
    await _db.collection('appointments').add({
      'patientId': patientId,
      'department': department,
      'date': date,
      'status': 'scheduled',
    });
  }

  Future<void> deleteAppointment(String appointmentId) async {
    await _db.collection('appointments').doc(appointmentId).delete();
  }
}
