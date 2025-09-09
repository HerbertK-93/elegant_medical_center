import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PatientRecordsScreen extends StatefulWidget {
  const PatientRecordsScreen({super.key});

  @override
  _PatientRecordsScreenState createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Records'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('patient_records')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No patient records found.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final Map<String, List<DocumentSnapshot>> groupedRecords = {};
          for (var doc in snapshot.data!.docs) {
            final name = (doc.data() as Map<String, dynamic>)['Name'];
            if (name != null) {
              if (!groupedRecords.containsKey(name)) {
                groupedRecords[name] = [];
              }
              groupedRecords[name]!.add(doc);
            }
          }

          if (groupedRecords.isEmpty) {
            return const Center(
              child: Text(
                'No patients found in the database.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: groupedRecords.length,
            itemBuilder: (context, index) {
              final name = groupedRecords.keys.elementAt(index);
              final records = groupedRecords[name]!;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: ExpansionTile(
                  leading: const Icon(Icons.person, color: Colors.teal),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${records.length} record(s)'),
                  children: records.map((record) {
                    return ListTile(
                      title: Text(record['Services'] ?? 'No Service'),
                      subtitle: Text('Date: ${record['Date']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.visibility, color: Colors.teal),
                        onPressed: () => _showRecordDetails(context, record),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showRecordDetails(BuildContext context, DocumentSnapshot record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final data = record.data() as Map<String, dynamic>;
        final isPaid = data['PaymentStatus'] == 'Paid';
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Patient Information",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20, thickness: 1.5),
                    _buildInfoRow('Name', data['Name']),
                    _buildInfoRow('Age', data['Age']),
                    _buildInfoRow('Contact', data['Contact']),
                    _buildInfoRow('Address', data['Address']),
                    _buildInfoRow('Services', data['Services']),
                    _buildInfoRow('Doctor Notes', data['DoctorNotes']),
                    _buildInfoRow('Payment Status', data['PaymentStatus']),
                    const SizedBox(height: 30),
                    if (isPaid) ...[
                      const Text(
                        "Receipt",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 20, thickness: 1.5),
                      _buildReceipt(data),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ),
          Expanded(
              child:
                  Text(value ?? 'N/A', style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildReceipt(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: const [
                Text(
                  "ELEGANT MEDICAL CENTER",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                SizedBox(height: 4),
                Text("LOCATION: KIRA, MULAWA"),
                Text("ADDRESS: P.O Box 456"),
                Text("CONTACT: +256 787 251008"),
              ],
            ),
          ),
          const Divider(height: 30, thickness: 1),
          _buildInfoRow('Patient Name', data['Name']),
          _buildInfoRow('Service', data['Service']),
          _buildInfoRow('Doctor', data['Doctor']),
          _buildInfoRow('Date', data['Date']),
          const Divider(height: 20, thickness: 1),
          _buildInfoRow(
              'Amount', 'UGX ${data['Amount']?.toStringAsFixed(2) ?? '0.00'}'),
          _buildInfoRow(
              'Total', 'UGX ${data['Total']?.toStringAsFixed(2) ?? '0.00'}'),
          const Divider(height: 30, thickness: 1),
          const Center(
              child: Text("Thank you for your visit!",
                  style: TextStyle(fontStyle: FontStyle.italic))),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _printReceipt(data),
              icon: const Icon(Icons.download, size: 18),
              label: const Text("Download/Print"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _printReceipt(Map<String, dynamic> data) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "ELEGANT MEDICAL CENTER",
                      style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(Colors.teal.value)),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text("LOCATION: KIRA, MULAWA"),
                    pw.Text("ADDRESS: P.O Box 456"),
                    pw.Text("CONTACT: +256 787 241008"),
                  ],
                ),
              ),
              pw.Divider(height: 30, thickness: 1),
              _buildPdfInfoRow('Patient Name', data['Name']),
              _buildPdfInfoRow('Service', data['Service']),
              _buildPdfInfoRow('Doctor', data['Doctor']),
              _buildPdfInfoRow('Date', data['Date']),
              pw.Divider(height: 20, thickness: 1),
              _buildPdfInfoRow('Amount',
                  'UGX ${data['Amount']?.toStringAsFixed(2) ?? '0.00'}'),
              _buildPdfInfoRow('Total',
                  'UGX ${data['Total']?.toStringAsFixed(2) ?? '0.00'}'),
              pw.Divider(height: 30, thickness: 1),
              pw.Center(
                  child: pw.Text("Thank you for your visit!",
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic))),
            ],
          );
        },
      ),
    );

    try {
      await Printing.sharePdf(
          bytes: await doc.save(), filename: 'receipt_${data['Name']}.pdf');
    } catch (e) {
      // Handle potential errors (e.g., no PDF viewer app installed)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }

  pw.Widget _buildPdfInfoRow(String label, dynamic value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(Colors.teal.value)),
            ),
          ),
          pw.Expanded(child: pw.Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}
