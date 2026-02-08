import 'package:flutter/material.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignments"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AssignmentCard(
            subject: "Mathematics",
            title: "Linear Algebra HW",
            due: "Due in 2 days",
            urgency: Urgency.medium,
          ),
          AssignmentCard(
            subject: "Computer Science",
            title: "Flutter UI Task",
            due: "Due Tomorrow",
            urgency: Urgency.high,
          ),
          AssignmentCard(
            subject: "Physics",
            title: "Numericals Set-3",
            due: "Due in 5 days",
            urgency: Urgency.low,
          ),
          AssignmentCard(
            subject: "Design Thinking",
            title: "Ideation Report",
            due: "Due in 1 week",
            urgency: Urgency.low,
          ),
        ],
      ),
    );
  }
}

/* ---------------- CARD ---------------- */

enum Urgency { high, medium, low }

class AssignmentCard extends StatelessWidget {
  final String subject;
  final String title;
  final String due;
  final Urgency urgency;

  const AssignmentCard({
    super.key,
    required this.subject,
    required this.title,
    required this.due,
    required this.urgency,
  });

  Color get urgencyColor {
    switch (urgency) {
      case Urgency.high:
        return Colors.red;
      case Urgency.medium:
        return Colors.orange;
      case Urgency.low:
        return Colors.green;
    }
  }

  String get urgencyText {
    switch (urgency) {
      case Urgency.high:
        return "URGENT";
      case Urgency.medium:
        return "SOON";
      case Urgency.low:
        return "NORMAL";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface, // ✅ DARK MODE FIX
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(subject),
                backgroundColor:
                    colorScheme.primary.withOpacity(0.12), // ✅ FIX
                labelStyle: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  urgencyText,
                  style: TextStyle(
                    color: urgencyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // ✅ FIX
            ),
          ),
          const SizedBox(height: 6),
          Text(
            due,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant, // ✅ FIX
            ),
          ),
        ],
      ),
    );
  }
}
