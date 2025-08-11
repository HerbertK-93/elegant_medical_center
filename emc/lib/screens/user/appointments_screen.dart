import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsScreen extends StatelessWidget {
  final String department;
  final _db = FirebaseFirestore.instance;

  AppointmentsScreen({required this.department});

  void _addAppointment(BuildContext context) {
    final patientIdController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Appointment"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: patientIdController,
              decoration: InputDecoration(labelText: "Patient ID")),
          TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: "Date (YYYY-MM-DD)")),
        ]),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              _db.collection('appointments').add({
                'patientId': patientIdController.text,
                'department': department,
                'date': DateTime.parse(dateController.text),
                'status': 'scheduled'
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$department Appointments"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addAppointment(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('appointments')
            .where('department', isEqualTo: department)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index];
              return ListTile(
                title: Text("Patient: ${data['patientId']}"),
                subtitle: Text(
                    "Date: ${data['date'].toDate()} - Status: ${data['status']}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _db.collection('appointments').doc(data.id).delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
