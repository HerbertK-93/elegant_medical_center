import 'package:elegant_medical_center/screens/otherscreens/billingmanagement.dart';
import 'package:elegant_medical_center/screens/otherscreens/patientsrecords.dart';
import 'package:elegant_medical_center/screens/otherscreens/reports.dart';
import 'package:elegant_medical_center/screens/otherscreens/staffmanagement.dart';
import 'package:elegant_medical_center/screens/user/appointments_screen.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'user_management_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHome extends StatelessWidget {
  final _authService = AuthService();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      endDrawer: _buildAdminDrawer(context),
      body: Row(
        children: [
          // Left Side Panel
          _buildSidePanel(context),

          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainAppBar(context),
                  SizedBox(height: 30),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildStatsGrid(),
                  SizedBox(height: 50),
                  _buildSectionTitle('Sales Analytics'),
                  SizedBox(height: 20),
                  // Placeholder for a chart or graph
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text('Analytics Chart Placeholder',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 50),
                  _buildSectionTitle('Latest Orders'),
                  SizedBox(height: 20),
                  // Placeholder for a data table
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text('Latest Orders Table Placeholder',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainAppBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search, color: Colors.blueGrey.shade400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        SizedBox(width: 20),
        IconButton(
          icon: Icon(Icons.notifications_none,
              color: Colors.blueGrey.shade600, size: 28),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.chat_bubble_outline,
              color: Colors.blueGrey.shade600, size: 28),
          onPressed: () {},
        ),
        SizedBox(width: 20),
        Builder(
          builder: (context) => InkWell(
            onTap: () => Scaffold.of(context).openEndDrawer(),
            borderRadius: BorderRadius.circular(50),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blueGrey.shade100,
              child:
                  Icon(Icons.person, color: Colors.blueGrey.shade800, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _buildStatCard('Total Patients', '1,200', Icons.people, Colors.blue),
        _buildStatCard('Total Staff', '2,102', Icons.group, Colors.green),
        _buildStatCard(
            'Total Appointments', '2,458', Icons.calendar_month, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 250,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade600,
                ),
              ),
              Icon(icon, size: 28, color: color),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade800,
      ),
    );
  }

  Widget _buildSidePanel(BuildContext context) {
    return Container(
      width: 280,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo placeholder
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.local_hospital, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text(
                'Elegant Medical',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          _buildSidePanelItem(context, 'Dashboard', Icons.dashboard, true),
          _buildSidePanelItem(
              context, 'Manage Users', Icons.people_alt_rounded, false, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => UserManagementScreen()));
          }),
          _buildSidePanelItem(
              context, 'Appointments', Icons.calendar_month_rounded, false, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AppointmentsScreen(
                          department: '',
                        )));
          }),
          _buildSidePanelItem(
              context, 'Patient Records', Icons.folder_open_rounded, false, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PatientRecordsScreen()));
          }),
          _buildSidePanelItem(
              context, 'Staff Management', Icons.group_rounded, false, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => StaffManagementScreen()));
          }),
          _buildSidePanelItem(
              context, 'Reports & Analytics', Icons.bar_chart_rounded, false,
              () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ReportsScreen()));
          }),
          _buildSidePanelItem(
              context, 'Billing', Icons.credit_card_rounded, false, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => BillingManagementScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildSidePanelItem(
      BuildContext context, String title, IconData icon, bool isSelected,
      [VoidCallback? onTap]) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue.shade600 : Colors.blueGrey.shade600,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade900 : Colors.blueGrey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    final uid = _auth.currentUser?.uid;
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              uid == null
                  ? Center(child: Text("No user logged in"))
                  : FutureBuilder<DocumentSnapshot>(
                      future: _firestore.collection("users").doc(uid).get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Container(
                            height: 200,
                            child: Center(child: Text("Profile not found")),
                          );
                        }

                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final name = userData["name"] ?? "N/A";
                        final email = userData["email"] ?? "N/A";

                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 32, horizontal: 24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo.shade800,
                                Colors.blueGrey.shade900
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person_rounded,
                                    size: 50, color: Colors.blueGrey),
                              ),
                              SizedBox(height: 16),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text("Profile"),
                onTap: () {
                  // Navigate to profile screen
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  // Navigate to settings screen
                },
              ),
              Divider(),
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
          ),
        ),
      ),
    );
  }
}
