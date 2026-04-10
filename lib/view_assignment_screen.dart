import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewAssignmentsScreen extends StatefulWidget {
  const ViewAssignmentsScreen({super.key});

  @override
  State<ViewAssignmentsScreen> createState() => _ViewAssignmentsScreenState();
}

class _ViewAssignmentsScreenState extends State<ViewAssignmentsScreen> {

  final supabase = Supabase.instance.client;

  List assignments = [];

  Future loadAssignments() async {
    final data = await supabase
        .from('assignments')
        .select()
        .order('deadline');

    setState(() {
      assignments = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Assignments")),

      body: assignments.isEmpty
          ? const Center(child: Text("No assignments uploaded"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assignments.length,
              itemBuilder: (context, index) {

                final a = assignments[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        a['title'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 6),

                      Text(a['description'] ?? ""),

                      const SizedBox(height: 6),

                      Text(
                        "Deadline: ${a['deadline']}",
                        style: const TextStyle(color: Colors.red),
                      ),

                    ],
                  ),
                );
              },
            ),
    );
  }
}