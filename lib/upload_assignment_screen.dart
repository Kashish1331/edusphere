import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadAssignmentScreen extends StatefulWidget {
  const UploadAssignmentScreen({super.key});

  @override
  State<UploadAssignmentScreen> createState() => _UploadAssignmentScreenState();
}

class _UploadAssignmentScreenState extends State<UploadAssignmentScreen> {

  final supabase = Supabase.instance.client;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<String> subjects = [];
  String? selectedSubject;

  int semester = 1;

  DateTime? deadline;

  Future loadSubjects() async {

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];

    final data = await supabase
        .from('timetable')
        .select()
        .eq('department', department)
        .eq('semester', semester);

    final Set<String> uniqueSubjects = {};

    for (var row in data) {
      uniqueSubjects.add(row['subject']);
    }

    setState(() {
      subjects = uniqueSubjects.toList();
      if (subjects.isNotEmpty) {
        selectedSubject = subjects.first;
      }
    });
  }

  Future uploadAssignment() async {

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];

    await supabase.from('assignments').insert({

      'subject': selectedSubject,
      'department': department,
      'semester': semester,
      'title': titleController.text,
      'description': descriptionController.text,
      'deadline': deadline?.toIso8601String()

    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Assignment Uploaded"))
    );

    Navigator.pop(context);
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
        title: const Text("Upload Assignment"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// SEMESTER SELECTOR

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

              onChanged: (value) {

                setState(() {
                  semester = value!;
                  subjects.clear();
                  selectedSubject = null;
                });

                loadSubjects();
              },
            ),

            const SizedBox(height: 16),

            /// SUBJECT SELECTOR

            if (subjects.isEmpty)
              const CircularProgressIndicator(),

            if (subjects.isNotEmpty)
              DropdownButtonFormField<String>(

                value: selectedSubject,

                decoration: const InputDecoration(
                  labelText: "Select Subject",
                ),

                items: subjects.map((subject) {

                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject),
                  );

                }).toList(),

                onChanged: (value) {

                  setState(() {
                    selectedSubject = value;
                  });

                },
              ),

            const SizedBox(height: 16),

            /// TITLE

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Assignment Title",
              ),
            ),

            const SizedBox(height: 16),

            /// DESCRIPTION

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 20),

            /// DEADLINE PICKER

            ElevatedButton(

              onPressed: () async {

                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                setState(() {
                  deadline = picked;
                });

              },

              child: const Text("Select Deadline"),

            ),

            const SizedBox(height: 20),

            /// UPLOAD BUTTON

            ElevatedButton(

              onPressed: uploadAssignment,

              child: const Text("Upload Assignment"),

            ),

          ],
        ),
      ),
    );
  }
}