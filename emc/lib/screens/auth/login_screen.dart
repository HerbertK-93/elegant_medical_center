import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../admin/admin_home.dart';
import '../user/user_home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? prefilledEmail; // 👈 new parameter

  const LoginScreen({Key? key, this.prefilledEmail}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;
  bool _obscurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 👇 initialize with prefilled email if provided
    _emailController = TextEditingController(
      text: widget.prefilledEmail ?? "",
    );

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

        if (!snap.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No profile found for this account.")));
          setState(() => _loading = false);
          return;
        }

        var data = snap.data()!;
        var role = data['role'] ?? 'user';

        if (role == 'admin') {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AdminHome()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => UserHome(),
              ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => _loading = false);
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
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
                      TextField(
                          controller: _emailController,
                          decoration: _inputDecoration("Email", Icons.email)),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: _inputDecoration(
                            "Password", Icons.lock_outline,
                            isPassword: true),
                        obscureText: _obscurePassword,
                      ),
                      SizedBox(height: 28),
                      _loading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                padding: EdgeInsets.zero,
                              ).copyWith(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                elevation: MaterialStateProperty.all(0),
                              ),
                              onPressed: _login,
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blueGrey, Colors.indigo],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("Login",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignUpScreen())),
                        child: Text("Don't have an account? Sign up",
                            style: TextStyle(
                                fontSize: 14, color: Colors.blueGrey.shade700)),
                      ),
                    ],
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
