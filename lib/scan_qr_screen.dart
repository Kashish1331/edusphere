import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {

  final supabase = Supabase.instance.client;
  bool scanned = false;

  Future markAttendance(String sessionId) async {

    final user = supabase.auth.currentUser;

    await supabase.from('attendance_records').insert({
      'student_id': user!.id,
      'session_id': sessionId
    });

    if(!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attendance Marked"))
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Scan Attendance QR")),

      body: MobileScanner(

        onDetect: (barcodeCapture) {

          if(scanned) return;

          final barcode = barcodeCapture.barcodes.first;
          final String? code = barcode.rawValue;

          if(code != null) {

            scanned = true;

            markAttendance(code);

          }

        },

      ),
    );
  }
}