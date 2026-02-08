import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
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
            attendanceCard(context, "Mathematics", 82),
            attendanceCard(context, "Computer Science", 68),
            attendanceCard(context, "Physics", 75),
            attendanceCard(context, "Design Thinking", 90),
          ],
        ),
      ),
    );
  }

  Widget attendanceCard(
      BuildContext context, String subject, int percentage) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface, // ✅ FIX
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
              color: colorScheme.onSurface, // ✅ FIX
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
