import 'package:elegant_medical_center/screens/departments/dentistry.dart';
import 'package:elegant_medical_center/screens/departments/orthopedics.dart';
import 'package:elegant_medical_center/screens/departments/radiology.dart';
import 'package:elegant_medical_center/screens/otherscreens/patientsrecords.dart';
import 'package:elegant_medical_center/screens/otherscreens/reports.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class UserHome extends StatelessWidget {
  final _authService = AuthService();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> departments = [
    {"name": "Dentistry", "icon": Icons.medical_services},
    {"name": "Radiology", "icon": Icons.monitor_heart},
    {"name": "Orthopedics", "icon": Icons.accessibility_new},
  ];

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: uid == null
              ? Center(child: Text("No user logged in"))
              : FutureBuilder<DocumentSnapshot>(
                  future: _firestore.collection("users").doc(uid).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text("Profile not found"));
                    }

                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final name = userData["name"] ?? "N/A";
                    final email = userData["email"] ?? "N/A";

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.shade100,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.blueGrey.shade300,
                                child: Icon(Icons.person,
                                    size: 48, color: Colors.white),
                              ),
                              SizedBox(height: 12),
                              Text(
                                name,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey.shade900),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blueGrey.shade700),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.settings,
                              color: Colors.blueGrey.shade700),
                          title: Text("Settings"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.info, color: Colors.blueGrey.shade700),
                          title: Text("About"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.redAccent),
                          title: Text("Logout"),
                          onTap: () async {
                            await _authService.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          },
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildSearchBar(),
            SizedBox(height: 20),
            // Insert the new Row for the buttons here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSmallButton(
                    context,
                    "Patient Records",
                    Colors.red,
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PatientRecordsScreen()))),
                SizedBox(width: 10), // A little space between the buttons
                _buildSmallButton(
                    context,
                    "Reports",
                    Colors.orange,
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ReportsScreen()))),
              ],
            ),
            SizedBox(height: 20), // Add some space before the department list
            Expanded(
              child: ListView.separated(
                itemCount: departments.length,
                separatorBuilder: (_, __) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final department = departments[index];
                  return _buildDepartmentCard(
                    context,
                    department["name"],
                    department["icon"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search patient by Name or ID",
          prefixIcon: Icon(Icons.search, color: Colors.blueGrey.shade700),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // New method for building the small buttons
  Widget _buildSmallButton(
      BuildContext context, String title, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: Size(150, 40),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDepartmentCard(
      BuildContext context, String department, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (department == "Dentistry") {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DentistryDashboard()));
        } else if (department == "Radiology") {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => RadiologyDashboard()));
        } else if (department == "Orthopedics") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => OrthopedicsDashboard()));
        }
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade50,
              Colors.blueGrey.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.blueGrey.shade300,
                    Colors.blueGrey.shade500,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    department,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Tap to open",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: Colors.blueGrey.shade700, size: 20),
          ],
        ),
      ),
    );
  }
}
