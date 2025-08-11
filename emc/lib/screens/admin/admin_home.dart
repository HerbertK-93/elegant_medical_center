import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'user_management_screen.dart';

class AdminHome extends StatelessWidget {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard - Elegant Medical Center"),
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
        crossAxisCount: 3,
        children: [
          _buildCard(context, "Manage Users", Icons.people, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => UserManagementScreen()));
          }),
          _buildCard(context, "Reports & Analytics", Icons.bar_chart, () {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Reports coming soon...")));
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
