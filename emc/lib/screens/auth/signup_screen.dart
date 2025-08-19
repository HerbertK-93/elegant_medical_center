import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = "user";
  String _department = "dentistry";
  final _authService = AuthService();
  bool _loading = false;
  bool _obscurePassword = true;

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

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
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
            colors: [Colors.purple.shade200, Colors.indigo.shade300],
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
                elevation: 16,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add_alt_1,
                            size: 64, color: Colors.purple.shade700),
                        SizedBox(height: 16),
                        Text("Create an Account",
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade800)),
                        SizedBox(height: 32),
                        TextField(
                            controller: _nameController,
                            decoration:
                                _inputDecoration("Full Name", Icons.person)),
                        SizedBox(height: 16),
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
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _role,
                          decoration: _inputDecoration(
                              "Role", Icons.admin_panel_settings),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.purple.shade700),
                          borderRadius: BorderRadius.circular(16),
                          items: ["admin", "user"]
                              .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500))))
                              .toList(),
                          onChanged: (val) => setState(() => _role = val!),
                        ),
                        if (_role == "user") ...[
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _department,
                            decoration:
                                _inputDecoration("Department", Icons.business),
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.arrow_drop_down,
                                color: Colors.purple.shade700),
                            borderRadius: BorderRadius.circular(16),
                            items: ["dentistry", "radiology", "orthopedics"]
                                .map((d) => DropdownMenuItem(
                                    value: d,
                                    child: Text(d,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _department = val!),
                          ),
                        ],
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
                                onPressed: _signup,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.purple, Colors.indigo],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text("Sign Up",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => LoginScreen())),
                          child: Text("Already have an account? Login",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.purple.shade700)),
                        ),
                      ],
                    ),
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
