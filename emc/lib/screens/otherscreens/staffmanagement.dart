import 'package:flutter/material.dart';

class StaffManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Management'),
        backgroundColor: Colors.purple.shade600,
      ),
      body: Center(
        child: Text(
          'This is the Staff Management screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
