import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Teacher Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 20),

            Text(
              "Logged in as:",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 10),

            Text(
              user?.email ?? "",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(

                icon: const Icon(Icons.logout),

                label: const Text("Logout"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),

                onPressed: () async {

                  await supabase.auth.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );

                },
              ),
            )

          ],
        ),
      ),
    );
  }
}