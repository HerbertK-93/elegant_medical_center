import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    var snap = await _db.collection('users').doc(_auth.currentUser!.uid).get();
    _nameController.text = snap['name'];
    _contactController.text = snap.data()?['contact'] ?? '';
  }

  void _updateProfile() async {
    await _db.collection('users').doc(_auth.currentUser!.uid).update({
      'name': _nameController.text,
      'contact': _contactController.text,
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Profile updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name")),
            TextField(
                controller: _contactController,
                decoration: InputDecoration(labelText: "Contact")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _updateProfile, child: Text("Update Profile")),
          ],
        ),
      ),
    );
  }
}
