import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

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

class DayTimetableScreen extends StatelessWidget {

  final String day;

  const DayTimetableScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("$day Timetable"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: const [

          TimetableTile(
            subject: "Operating Systems",
            time: "9:00 - 10:00",
            type: "Lecture",
          ),

          TimetableTile(
            subject: "Computer Networks",
            time: "10:00 - 11:00",
            type: "Lecture",
          ),

          TimetableTile(
            subject: "Machine Learning Lab",
            time: "2:00 - 4:00",
            type: "Lab",
          ),
        ],
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