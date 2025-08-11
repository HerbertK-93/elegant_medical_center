import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../admin/admin_home.dart';
import '../user/user_home.dart';
import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    try {
      User? user = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        var snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        var role = snap['role'];
        if (role == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminHome()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => UserHome(department: snap['department']),
              ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Elegant Medical Center",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email")),
                  TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true),
                  SizedBox(height: 20),
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(onPressed: _login, child: Text("Login")),
                  TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignUpScreen())),
                    child: Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
