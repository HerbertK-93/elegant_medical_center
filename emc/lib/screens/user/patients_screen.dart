import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsScreen extends StatelessWidget {
  final String department;
  final _db = FirebaseFirestore.instance;

  PatientsScreen({required this.department});

  void _addPatient(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Patient"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name")),
          TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: "Age")),
          TextField(
              controller: contactController,
              decoration: InputDecoration(labelText: "Contact")),
        ]),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              _db.collection('patients').add({
                'name': nameController.text,
                'age': int.parse(ageController.text),
                'contact': contactController.text,
                'department': department,
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
        title: Text("$department Patients"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addPatient(context),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('patients')
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
                title: Text(data['name']),
                subtitle:
                    Text("Age: ${data['age']} - Contact: ${data['contact']}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      _db.collection('patients').doc(data.id).delete(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
