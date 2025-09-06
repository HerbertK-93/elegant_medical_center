import 'package:flutter/material.dart';

class DentistryDashboard extends StatelessWidget {
  const DentistryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Dentistry Department",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.teal[700]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: 0.9,
          children: [
            _buildDashboardCard(
              context,
              label: "Patient Record",
              color: Colors.teal,
              icon: Icons.person,
              onTap: () => _showPatientRecordSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Dashboard Card
  Widget _buildDashboardCard(BuildContext context,
      {required String label,
      required Color color,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 28, color: Colors.white),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Combined Patient Record Dialog
  void _showPatientRecordSheet(BuildContext context) {
    final dateController = TextEditingController();
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final contactController = TextEditingController();
    final addressController = TextEditingController();
    final reasonController = TextEditingController();
    final notesController = TextEditingController();

    final serviceController = TextEditingController();
    final doctorController = TextEditingController();
    final amountController = TextEditingController();
    final totalController = TextEditingController();

    String paymentStatus = "Pending"; // default

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Patient Record",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, // wider dialog
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Patient Info
                      const Text("Patient Info",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildTextField("Date", dateController),
                      _buildTextField("Full Name", nameController),
                      _buildTextField("Age", ageController,
                          keyboard: TextInputType.number),
                      _buildTextField("Contact Number", contactController,
                          keyboard: TextInputType.phone),
                      _buildTextField("Address", addressController),
                      _buildTextField("Reason", reasonController),
                      _buildTextField("Doctor Notes", notesController,
                          maxLines: 3),

                      const Divider(thickness: 1, height: 24),

                      /// Payment Status (Choice Chips instead of dropdown)
                      const Text("Payment Status",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: [
                          ChoiceChip(
                            label: const Text("Pending"),
                            selected: paymentStatus == "Pending",
                            onSelected: (selected) {
                              if (selected)
                                setState(() => paymentStatus = "Pending");
                            },
                            selectedColor: Colors.teal,
                            labelStyle: TextStyle(
                              color: paymentStatus == "Pending"
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ChoiceChip(
                            label: const Text("Paid"),
                            selected: paymentStatus == "Paid",
                            onSelected: (selected) {
                              if (selected)
                                setState(() => paymentStatus = "Paid");
                            },
                            selectedColor: Colors.teal,
                            labelStyle: TextStyle(
                              color: paymentStatus == "Paid"
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      /// Receipt Info (only if Paid)
                      if (paymentStatus == "Paid") ...[
                        const Divider(thickness: 1, height: 24),
                        const Text("Receipt",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _buildTextField("Service", serviceController),
                        _buildTextField("Doctor", doctorController),
                        _buildTextField("Amount", amountController,
                            keyboard: TextInputType.number),
                        _buildTextField("Total", totalController,
                            keyboard: TextInputType.number),
                      ]
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final recordData = {
                      "Date": dateController.text,
                      "Name": nameController.text,
                      "Age": ageController.text,
                      "Contact": contactController.text,
                      "Address": addressController.text,
                      "Reason": reasonController.text,
                      "DoctorNotes": notesController.text,
                      "PaymentStatus": paymentStatus,
                      if (paymentStatus == "Paid") ...{
                        "Service": serviceController.text,
                        "Doctor": doctorController.text,
                        "Amount": amountController.text,
                        "Total": totalController.text,
                      }
                    };
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Saved: $recordData")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text("Save Record"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Reusable TextField
  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
