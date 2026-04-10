import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GenerateQRScreen extends StatefulWidget {

  final String day;

  const GenerateQRScreen({super.key, required this.day});

  @override
  State<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {

  final supabase = Supabase.instance.client;

  List subjects = [];

  String? subject;

  String? sessionId;

  Future loadSubjects() async {

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];
    final semester = userData['semester'];

    final data = await supabase
        .from('timetable')
        .select()
        .eq('department', department)
        .eq('semester', semester)
        .eq('day', widget.day);

    setState(() {
      subjects = data;
      if (subjects.isNotEmpty) {
        subject = subjects.first['subject'];
      }
    });
  }

  Future generateQR() async {

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];
    final semester = userData['semester'];

    final expires = DateTime.now().add(const Duration(seconds: 30));

    final res = await supabase
        .from('attendance_sessions')
        .insert({
          'subject': subject,
          'department': department,
          'semester': semester,
          'day': widget.day,
          'expires_at': expires.toIso8601String()
        })
        .select()
        .single();

    setState(() {
      sessionId = res['id'];
    });

    Future.delayed(const Duration(seconds: 30), () {

      if (!mounted) return;

      setState(() {
        sessionId = null;
      });

    });
  }

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("QR Attendance - ${widget.day}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            if (subjects.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),

            if (subjects.isNotEmpty)

              DropdownButtonFormField(

                value: subject,

                items: subjects.map((s) {

                  return DropdownMenuItem(
                    value: s['subject'],
                    child: Text(s['subject']),
                  );

                }).toList(),

                onChanged: (v) {
                  setState(() {
                    subject = v as String?;
                  });
                },
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: generateQR,
              child: const Text("Generate QR"),
            ),

            const SizedBox(height: 30),

            if (sessionId != null)
              QrImageView(
                data: sessionId!,
                size: 220,
              ),

            if (sessionId != null)
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("QR expires in 30 seconds"),
              )

          ],
        ),
      ),
    );
  }
}