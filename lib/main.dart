import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'attendance_screen.dart';
import 'campus_mapscreen.dart';
import 'student_profile_screen.dart';
import 'signup_screen.dart';
import 'fee_portal_screen.dart';
import 'timetable_screen.dart';
import 'holidays_screen.dart';
import 'ai_chat_screen.dart';
import 'package:flutter/material.dart';
import 'generate_qr_screen.dart';
import 'upload_assignment_screen.dart';
import 'timetable_screen.dart';
import 'view_assignment_screen.dart';
import 'qr_attendance_screen.dart';
import 'teacher_profile_screen.dart';
import 'package:confetti/confetti.dart';
import 'upload_event_screen.dart';

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://brkbprjnplojequphmyt.supabase.co',
    anonKey: 'sb_publishable_mBLeupIO4MB_BzR7KWjiTQ_zKllViwT',
  );


  runApp(const EduSphere());
}

class EduSphere extends StatelessWidget {
  const EduSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "EduSphere",
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: "Roboto",
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: "Roboto",
            useMaterial3: true,
          ),
          themeMode: currentMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}


/* ---------------- SPLASH ---------------- */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/logo.png", width: 140),
                const SizedBox(height: 30),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'EduSphere',
                      textStyle: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
                const SizedBox(height: 10),
                AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'Smart Campus Companion',
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- LOGIN ---------------- */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> login() async {
  try {
    final res = await supabase.auth.signInWithPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    final user = res.user;

    if (user != null) {

      final data = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      if (data['role'] == 'student') {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentHome()),
        );

      } else {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TeacherDashboard()),
        );

      }
    }

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login Failed: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: "Password"),
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: login,
                  child: const Text("LOGIN"),
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- ROLE SELECTION ---------------- */

class RoleSelection extends StatelessWidget {
  const RoleSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Role"),
        backgroundColor: const Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            roleCard(context, "Student", Icons.school, const StudentHome()),
            const SizedBox(height: 20),
            roleCard(context, "Teacher", Icons.person, const TeacherDashboard()),
          ],
        ),
      ),
    );
  }

  Widget roleCard(
      BuildContext context, String text, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

/* ---------------- STUDENT HOME ---------------- */

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int index = 0;

  final screens = [
  const StudentDashboard(),
  const AttendanceScreen(),
  const CampusMapScreen(),
  const StudentProfileScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff6A5AE0),
        onTap: (i) => setState(() => index = i),
        items: const [
  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
  BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "Attendance"),
  BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
],
      ),
    );
  }
}

/* ---------------- STUDENT DASHBOARD ---------------- */

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {

  Future<List<dynamic>> fetchEvents() async {

    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('campus_events')
        .select()
        .order('event_date');

    return data;
  }

  Widget eventNotification(Map event) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          const Text(
            "📢",
            style: TextStyle(fontSize: 22),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  event['title'] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  event['description'] ?? "",
                  style: const TextStyle(fontSize: 13),
                ),

              ],
            ),
          ),

          const Text("📅")
        ],
      ),
    );
  }

  Widget card(
      BuildContext context, IconData icon, String title, Widget screen) {

    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(

      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),

      child: Container(

        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),

        child: Row(
          children: [

            Icon(icon, color: colorScheme.primary, size: 30),

            const SizedBox(width: 20),

            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: const Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// EVENT NOTIFICATIONS
            FutureBuilder(

              future: fetchEvents(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final events = snapshot.data as List;

                if (events.isEmpty) {
                  return const SizedBox();
                }

                return Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Campus Events",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...events.take(3).map((e) => eventNotification(e)),

                    const SizedBox(height: 20),

                  ],
                );
              },
            ),

            /// DASHBOARD FEATURES

            card(context, Icons.check_circle, "Attendance", const AttendanceScreen()),

            card(context, Icons.assignment, "Assignments", const ViewAssignmentsScreen()),

            card(context, Icons.map, "Campus Map", const CampusMapScreen()),

            card(context, Icons.account_balance_wallet, "Fee Portal", const FeePortalScreen()),

            card(context, Icons.schedule, "Timetable", const TimetableScreen()),

            card(context, Icons.calendar_month, "Upcoming Holidays", const HolidaysScreen()),

            card(context, Icons.smart_toy, "AI Assistant", const AIChatScreen()),

          ],
        ),
      ),
    );
  }
}
/* ---------------- TEACHER DASHBOARD ---------------- */

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            teacherCard(
              context,
              Icons.qr_code,
              "QR Attendance",
              const QRAttendanceScreen(),
            ),

            teacherCard(
              context,
              Icons.assignment,
              "Upload Assignment",
              const UploadAssignmentScreen(),
            ),

            teacherCard(
              context,
              Icons.report_problem,
              "Raise Complaint",
              const ComplaintScreen(),
            ),

            teacherCard(
              context,
              Icons.person,
              "Profile",
              TeacherProfileScreen(),
            ),

            teacherCard(
  context,
  Icons.event,
  "Upload Campus Event",
  UploadEventScreen(),
),

          ],
        ),
      ),
    );
  }

  Widget teacherCard(
    BuildContext context,
    IconData icon,
    String text,
    Widget screen,
  ) {

    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),

        child: Row(
          children: [

            Icon(icon, color: colorScheme.primary, size: 30),

            const SizedBox(width: 20),

            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- COMPLAINT ---------------- */
class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {

  final classroomController = TextEditingController();
  final issueController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future submitComplaint() async {

    await supabase.from('complaints').insert({
      'classroom': classroomController.text,
      'issue': issueController.text,
      'created_at': DateTime.now().toIso8601String()
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint Submitted"))
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Raise Complaint"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: classroomController,
              decoration: const InputDecoration(labelText: "Classroom"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: issueController,
              decoration: const InputDecoration(labelText: "Issue"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: submitComplaint,
              child: const Text("Submit Complaint"),
            ),

          ],
        ),
      ),
    );
  }
}