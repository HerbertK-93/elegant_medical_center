import 'package:flutter/material.dart';

class BillingManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing Management'),
        backgroundColor: Colors.red.shade600,
      ),
      body: Center(
        child: Text(
          'This is the Billing Management screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
