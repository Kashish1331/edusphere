import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {

  bool darkMode = false;
  bool notifications = true;

  final supabase = Supabase.instance.client;

  String name = "";
  String email = "";
  String roll = "";
  String department = "";
  int semester = 1;
  String specialization = "None";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {

  final user = supabase.auth.currentUser;

  final response = await supabase
    .from('users')
    .select()
    .eq('id', user!.id);

if (response.isEmpty) return;

final data = response.first;

  if (data == null) return;

  setState(() {

    name = data['name'] ?? "";

    email = data['email'] ?? "";

    roll = data['roll_number'] ?? "";

    department = data['department'] ?? "";

    semester = int.tryParse(data['semester'].toString()) ?? 1;

    specialization = data['specialization'] ?? "None";
  });
}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    darkMode = Theme.of(context).brightness == Brightness.dark;
  }

  Widget infoTile(
      BuildContext context, IconData icon, String title, String value) {

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget switchTile(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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

      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(icon, color: colorScheme.primary),

        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),

        value: value,
        activeColor: colorScheme.primary,

        onChanged: onChanged,
      ),
    );
  }

  String getInitials() {

    if (name.isEmpty) return "";

    List parts = name.split(" ");

    if (parts.length == 1) {
      return parts[0][0];
    }

    return parts[0][0] + parts[1][0];
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      backgroundColor: colorScheme.background,

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            /// Profile Header
            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(

                children: [

                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,

                    child: Text(
                      getInitials(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff6A5AE0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            infoTile(context, Icons.badge, "Roll Number", roll),
            infoTile(context, Icons.school, "Department", department),
            infoTile(context, Icons.timeline, "Semester", "Semester $semester"),
            infoTile(context, Icons.psychology, "Specialization", specialization),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Settings",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),

            const SizedBox(height: 12),

            switchTile(context, Icons.dark_mode, "Dark Mode", darkMode, (val) {

              setState(() {
                darkMode = val;
              });

              themeNotifier.value =
                  val ? ThemeMode.dark : ThemeMode.light;
            }),

            switchTile(
                context,
                Icons.notifications,
                "Notifications",
                notifications,
                (val) {

              setState(() {
                notifications = val;
              });

            }),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () {

                  supabase.auth.signOut();

                  Navigator.pop(context);

                },

                icon: const Icon(Icons.logout),

                label: const Text(
                  "Logout",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}