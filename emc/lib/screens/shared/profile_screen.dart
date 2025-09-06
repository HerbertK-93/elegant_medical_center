import 'package:elegant_medical_center/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _logout() async {
    await _authService.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  Widget _infoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey.shade700),
      title: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900)),
      subtitle: Text(value, style: TextStyle(color: Colors.blueGrey.shade700)),
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.blueGrey.shade50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.blueGrey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox(
              width: 420,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                elevation: 12,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: uid == null
                      ? Center(child: Text("No user logged in"))
                      : FutureBuilder<DocumentSnapshot>(
                          future: _firestore.collection("users").doc(uid).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Center(
                                  child: Text("User profile not found"));
                            }

                            final userData =
                                snapshot.data!.data() as Map<String, dynamic>;

                            final name = userData["name"] ?? "N/A";
                            final email = userData["email"] ?? "N/A";
                            final role = userData["role"] ?? "N/A";

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_hospital,
                                    size: 64, color: Colors.blueGrey.shade700),
                                SizedBox(height: 16),
                                Text("Elegant Medical Clinic",
                                    style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey.shade900)),
                                SizedBox(height: 32),
                                _infoTile("Full Name", name, Icons.person),
                                SizedBox(height: 12),
                                _infoTile("Email", email, Icons.email),
                                SizedBox(height: 12),
                                _infoTile(
                                    "Role", role, Icons.admin_panel_settings),
                                SizedBox(height: 28),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    padding: EdgeInsets.zero,
                                  ).copyWith(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    elevation: MaterialStateProperty.all(0),
                                  ),
                                  onPressed: _logout,
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blueGrey,
                                          Colors.indigo
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Log Out",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
