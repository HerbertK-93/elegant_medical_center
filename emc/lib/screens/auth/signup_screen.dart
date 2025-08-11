import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = "user";
  String _department = "dentistry";
  final _authService = AuthService();
  bool _loading = false;

  void _signup() async {
    setState(() => _loading = true);
    try {
      await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        _role,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Account created successfully! Please login.")));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
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
                  Text("Sign Up",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Full Name")),
                  TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email")),
                  TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true),
                  DropdownButton<String>(
                    value: _role,
                    items: ["admin", "user"]
                        .map((role) =>
                            DropdownMenuItem(value: role, child: Text(role)))
                        .toList(),
                    onChanged: (val) => setState(() => _role = val!),
                  ),
                  if (_role == "user")
                    DropdownButton<String>(
                      value: _department,
                      items: ["dentistry", "radiology", "orthopedics"]
                          .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) => setState(() => _department = val!),
                    ),
                  SizedBox(height: 20),
                  _loading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _signup, child: Text("Sign Up")),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen())),
                    child: Text("Already have an account? Login"),
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
