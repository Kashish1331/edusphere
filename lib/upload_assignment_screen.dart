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

  DateTime? deadline;

  Future<void> loadSubjects() async {

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];
    final semester = userData['semester'];

    final response = await supabase
        .from('timetable')
        .select('subject')
        .eq('department', department)
        .eq('semester', semester);

    /// convert response safely to List<String>
    List<String> subjectList = [];

    for (var item in response) {
      subjectList.add(item['subject'].toString());
    }

    /// remove duplicates
    subjectList = subjectList.toSet().toList();

    setState(() {
      subjects = subjectList;

      if (subjects.isNotEmpty) {
        selectedSubject = subjects.first;
      }
    });
  }

  Future<void> uploadAssignment() async {

    if (selectedSubject == null ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        deadline == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    final department = userData['department'];
    final semester = userData['semester'];

    await supabase.from('assignments').insert({

      'subject': selectedSubject,
      'department': department,
      'semester': semester,
      'title': titleController.text,
      'description': descriptionController.text,
      'deadline': deadline!.toIso8601String()

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

            /// SUBJECT DROPDOWN

            if (subjects.isEmpty)
              const CircularProgressIndicator(),

            if (subjects.isNotEmpty)
              DropdownButtonFormField<String>(

                value: selectedSubject,

                items: subjects.map((sub) {
                  return DropdownMenuItem<String>(
                    value: sub,
                    child: Text(sub),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
              ),

            const SizedBox(height: 12),

            /// TITLE

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Assignment Title",
              ),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 20),

            /// DATE PICKER

            ElevatedButton(

              onPressed: () async {

                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                if (picked != null) {
                  setState(() {
                    deadline = picked;
                  });
                }

              },

              child: const Text("Select Deadline"),

            ),

            const SizedBox(height: 10),

            if (deadline != null)
              Text(
                "Deadline: ${deadline!.day}/${deadline!.month}/${deadline!.year}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20),

            /// UPLOAD BUTTON

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: uploadAssignment,

                child: const Text("Upload Assignment"),

              ),
            ),

          ],
        ),
      ),
    );
  }
}