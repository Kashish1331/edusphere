import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  final List<String> days = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timetable"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final day = days[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DayTimetableScreen(day: day),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DayTimetableScreen extends StatefulWidget {
  final String day;

  const DayTimetableScreen({super.key, required this.day});

  @override
  State<DayTimetableScreen> createState() => _DayTimetableScreenState();
}

class _DayTimetableScreenState extends State<DayTimetableScreen> {

  final supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchTimetable() async {

    final user = supabase.auth.currentUser;

    if (user == null) return [];

    /// FETCH USER DATA
    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    final semester = userData['semester'];
    final department = userData['department'];
    String specialization = userData['specialization'] ?? "None";

    /// FIX possible mismatch
    if (specialization == "None (First Year)") {
      specialization = "None";
    }

    /// DEBUG PRINTS
    print("----- TIMETABLE QUERY -----");
    print("Department: $department");
    print("Semester: $semester");
    print("Specialization: $specialization");
    print("Day: ${widget.day}");

    /// FETCH TIMETABLE
    final data = await supabase
    .from('timetable')
    .select()
    .eq('department', department)
    .eq('semester', semester)
    .eq('day', widget.day)
    .order('time');

    print("Rows returned: ${data.length}");

    return data;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.day} Timetable"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchTimetable(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading timetable"));
          }

          final classes = snapshot.data ?? [];

          if (classes.isEmpty) {
            return const Center(child: Text("No classes scheduled"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: classes.length,
            itemBuilder: (context, index) {

              final c = classes[index];

              return TimetableTile(
                subject: c['subject'],
                time: c['time'],
                type: c['type'],
              );
            },
          );
        },
      ),
    );
  }
}

class TimetableTile extends StatelessWidget {

  final String subject;
  final String time;
  final String type;

  const TimetableTile({
    super.key,
    required this.subject,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [

          Icon(
            type == "Lab" ? Icons.science : Icons.menu_book,
            color: colorScheme.primary,
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                subject,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                time,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              Text(
                type,
                style: TextStyle(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}