import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {

  final supabase = Supabase.instance.client;

  List holidays = [];

  final List<String> quotes = [
    "Take breaks. Even the sun rests at night.",
    "Study hard, celebrate harder.",
    "A balanced student is a successful student.",
    "Rest today. Rise stronger tomorrow.",
    "Holidays are proof that life is more than assignments."
  ];

  String quote = "";

  @override
  void initState() {
    super.initState();
    quote = quotes[Random().nextInt(quotes.length)];
    loadHolidays();
  }

  Future<void> loadHolidays() async {

    final data = await supabase
        .from('holidays')
        .select()
        .order('date');

    setState(() {
      holidays = data;
    });
  }

  String formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day}/${d.month}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Holidays"),
        backgroundColor: const Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [

          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
              ),
            ),
            child: Column(
              children: [

                const Text(
                  "2026",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// HOLIDAY LIST
          Expanded(
            child: holidays.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: holidays.length,
                    itemBuilder: (context, index) {

                      final holiday = holidays[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                            )
                          ],
                        ),

                        child: Row(
                          children: [

                            /// DATE ICON
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xff6A5AE0)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calendar_month,
                                color: Color(0xff6A5AE0),
                              ),
                            ),

                            const SizedBox(width: 16),

                            /// HOLIDAY INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    holiday['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    formatDate(holiday['date']),
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    holiday['description'] ?? "",
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}