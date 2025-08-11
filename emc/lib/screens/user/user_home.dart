import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'appointments_screen.dart';
import 'patients_screen.dart';

class UserHome extends StatelessWidget {
  final String department;
  final _authService = AuthService();

  UserHome({required this.department});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$department Department Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          )
        ],
      ),
      body: GridView.count(
        padding: EdgeInsets.all(20),
        crossAxisCount: 2,
        children: [
          _buildCard(context, "Manage Appointments", Icons.calendar_today, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        AppointmentsScreen(department: department)));
          }),
          _buildCard(context, "Manage Patients", Icons.person, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => PatientsScreen(department: department)));
          }),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 50, color: Colors.blue),
          SizedBox(height: 10),
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}
