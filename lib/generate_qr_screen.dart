import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GenerateQRScreen extends StatefulWidget {
  const GenerateQRScreen({super.key});

  @override
  State<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {

  final supabase = Supabase.instance.client;

  int? semester;
  List<String> subjects = [];
  String? subject;

  String? sessionId;

  Future loadSubjects() async {

    if (semester == null) return;

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];

    final data = await supabase
        .from('timetable')
        .select('subject')
        .eq('department', department)
        .eq('semester', semester!);

    /// remove duplicate subjects
    final uniqueSubjects = data
        .map((e) => e['subject'] as String)
        .toSet()
        .toList();

    setState(() {
      subjects = uniqueSubjects;
      subject = null;
    });
  }

  Future generateQR() async {

    if (subject == null || semester == null) return;

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];

    final expires = DateTime.now().add(const Duration(seconds: 30));

    final res = await supabase
        .from('attendance_sessions')
        .insert({
          'subject': subject,
          'department': department,
          'semester': semester,
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
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Generate Attendance QR"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// SEMESTER SELECT

            DropdownButtonFormField<int>(

              value: semester,

              decoration: const InputDecoration(
                labelText: "Select Semester",
              ),

              items: List.generate(
                8,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text("Semester ${index + 1}"),
                ),
              ),

              onChanged: (v) {

                setState(() {
                  semester = v;
                  subjects = [];
                  subject = null;
                });

                loadSubjects();
              },
            ),

            const SizedBox(height: 20),

            /// SUBJECT SELECT

            if (subjects.isEmpty && semester != null)
              const CircularProgressIndicator(),

            if (subjects.isNotEmpty)

              DropdownButtonFormField<String>(

                value: subject,

                decoration: const InputDecoration(
                  labelText: "Select Subject",
                ),

                items: subjects.map((s) {

                  return DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  );

                }).toList(),

                onChanged: (v) {
                  setState(() {
                    subject = v;
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