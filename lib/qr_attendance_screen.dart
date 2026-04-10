import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';

class QRAttendanceScreen extends StatelessWidget {
  const QRAttendanceScreen({super.key});

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
        title: const Text("Select Day"),
      ),

      body: ListView.builder(

        itemCount: days.length,

        itemBuilder: (context, index) {

          final day = days[index];

          return ListTile(

            title: Text(day),

            trailing: const Icon(Icons.arrow_forward),

            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GenerateQRScreen(day: day),
                ),
              );

            },

          );
        },
      ),
    );
  }
}