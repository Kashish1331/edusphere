import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'scan_qr_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  final supabase = Supabase.instance.client;

  Future<int> getAttendancePercent(String subject) async {

    final user = supabase.auth.currentUser;

    if (user == null) return 0;

    final sessions = await supabase
        .from('attendance_sessions')
        .select()
        .eq('subject', subject);

    if (sessions.isEmpty) return 0;

    int totalSessions = sessions.length;

    int attended = 0;

    for (var session in sessions) {

      final record = await supabase
          .from('attendance_records')
          .select()
          .eq('session_id', session['id'])
          .eq('student_id', user.id);

      if (record.isNotEmpty) {
        attended++;
      }
    }

    return ((attended / totalSessions) * 100).round();
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// SCAN QR BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(

                icon: const Icon(Icons.qr_code_scanner),

                label: const Text("Scan Attendance QR"),

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: const Color(0xff6A5AE0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScanQRScreen(),
                    ),
                  );

                },
              ),
            ),

            const SizedBox(height: 20),

            /// ATTENDANCE LIST
            Expanded(
              child: ListView(
                children: [

                  buildAttendance("Mathematics"),
                  buildAttendance("Programming"),
                  buildAttendance("Physics"),
                  buildAttendance("Design Thinking"),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildAttendance(String subject) {

    return FutureBuilder(

      future: getAttendancePercent(subject),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        int percent = snapshot.data as int;

        return attendanceCard(context, subject, percent);
      },
    );
  }

  Widget attendanceCard(
      BuildContext context, String subject, int percentage) {

    final colorScheme = Theme.of(context).colorScheme;

    return Container(

      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            subject,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          Text(
            "$percentage%",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: percentage < 75 ? Colors.red : Colors.green,
            ),
          ),

        ],
      ),
    );
  }
}