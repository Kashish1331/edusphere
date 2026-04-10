import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadEventScreen extends StatefulWidget {
  const UploadEventScreen({super.key});

  @override
  State<UploadEventScreen> createState() => _UploadEventScreenState();
}

class _UploadEventScreenState extends State<UploadEventScreen> {

  final supabase = Supabase.instance.client;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? eventDate;

  Future uploadEvent() async {

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        eventDate == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await supabase.from('campus_events').insert({

      'title': titleController.text,
      'description': descriptionController.text,
      'event_date': eventDate!.toIso8601String(),

    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Uploaded Successfully 🎉"))
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Upload Campus Event"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Event Title",
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 20),

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
                    eventDate = picked;
                  });
                }

              },

              child: const Text("Select Event Date"),

            ),

            const SizedBox(height: 10),

            if (eventDate != null)
              Text(
                "Selected Date: ${eventDate!.day}/${eventDate!.month}/${eventDate!.year}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                onPressed: uploadEvent,

                child: const Text("Upload Event"),

              ),
            ),

          ],
        ),
      ),
    );
  }
}