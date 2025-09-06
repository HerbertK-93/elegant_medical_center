import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Center(
        child: Text(
          'This is the Appointments screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
