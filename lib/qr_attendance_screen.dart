import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generate_qr_screen.dart';

class QRAttendanceScreen extends StatefulWidget {
  const QRAttendanceScreen({super.key});

  @override
  State<QRAttendanceScreen> createState() => _QRAttendanceScreenState();
}

class _QRAttendanceScreenState extends State<QRAttendanceScreen> {

  final supabase = Supabase.instance.client;

  int? selectedSemester;
  List<String> subjects = [];

  Future loadSubjects() async {

    if (selectedSemester == null) return;

    final user = supabase.auth.currentUser;

    final teacherData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = teacherData['department'];

    final data = await supabase
        .from('timetable')
        .select('subject')
        .eq('department', department)
        .eq('semester', selectedSemester!)
        .order('subject');

    /// remove duplicate subjects
    final uniqueSubjects = data
        .map((e) => e['subject'] as String)
        .toSet()
        .toList();

    setState(() {
      subjects = uniqueSubjects;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("QR Attendance"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// SEMESTER SELECT
            DropdownButtonFormField<int>(

              hint: const Text("Select Semester"),

              items: List.generate(
                8,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text("Semester ${index + 1}"),
                ),
              ),

              onChanged: (value) {

                setState(() {
                  selectedSemester = value;
                  subjects = [];
                });

                loadSubjects();
              },
            ),

            const SizedBox(height: 20),

            /// SUBJECT LIST
            if (subjects.isEmpty && selectedSemester != null)
              const CircularProgressIndicator(),

            if (subjects.isEmpty && selectedSemester == null)
              const Text("Select semester to load subjects"),

            if (subjects.isNotEmpty)

              Expanded(
                child: ListView.builder(

                  itemCount: subjects.length,

                  itemBuilder: (context, index) {

                    final subject = subjects[index];

                    return ListTile(

                      title: Text(subject),

                      trailing: const Icon(Icons.qr_code),

                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GenerateQRScreen(),
                          ),
                        );

                      },

                    );

                  },

                ),
              ),

          ],
        ),
      ),
    );
  }
}