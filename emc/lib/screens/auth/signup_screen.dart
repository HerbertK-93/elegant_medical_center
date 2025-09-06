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
  final _adminKeyController = TextEditingController();

  String _role = "user";
  final _authService = AuthService();
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureAdminKey = true;

  static const String ADMIN_KEY = "f9enmwdk*72XWJ#-\$@!";

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
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final name = _nameController.text.trim();

      // Debug logs
      print("📌 Attempting signup");
      print("  Email: $email");
      print("  Name: $name");
      print("  Role: $_role");

      // Validate email format
      if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email)) {
        throw Exception("Please enter a valid email address");
      }

      // Admin requires key
      if (_role == "admin" && _adminKeyController.text.trim() != ADMIN_KEY) {
        throw Exception("Invalid Administration Key");
      }

      // Call AuthService (department removed)
      await _authService.signUp(
        email,
        password,
        name,
        _role,
      );

      print("✅ Signup finished successfully");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully! Please login.")),
      );

      // Wait 2 seconds so CircularProgressIndicator is visible
      await Future.delayed(Duration(seconds: 2));

      setState(() => _loading = false);

      // Navigate to login screen and pass the email for autofill
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            prefilledEmail: email,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      print("🔥 Error during signup: $e"); // Debug error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool isPassword = false, bool isAdminKey = false}) {
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
          : isAdminKey
              ? IconButton(
                  icon: Icon(
                    _obscureAdminKey ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _obscureAdminKey = !_obscureAdminKey),
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
                  child: SingleChildScrollView(
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
                              color: Colors.blueGrey.shade700),
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
                        if (_role == "admin") ...[
                          SizedBox(height: 16),
                          TextField(
                            controller: _adminKeyController,
                            decoration: _inputDecoration(
                                "Administration Key", Icons.vpn_key,
                                isAdminKey: true),
                            obscureText: _obscureAdminKey,
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
                                      colors: [Colors.blueGrey, Colors.indigo],
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
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(
                                prefilledEmail: _emailController.text.trim(),
                              ),
                            ),
                          ),
                          child: Text("Already have an account? Login",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueGrey.shade700)),
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
