import 'package:flutter/material.dart';

void main() {
  runApp(EduSphere());
}

class EduSphere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduSphere',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SplashScreen(),
    );
  }
}

/* ---------------- SPLASH SCREEN ---------------- */

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Text(
          'EduSphere',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}

/* ---------------- LOGIN SCREEN ---------------- */

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RoleSelection()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

/* ---------------- ROLE SELECTION ---------------- */

class RoleSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Student'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StudentDashboard()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Teacher'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TeacherDashboard()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- STUDENT DASHBOARD ---------------- */

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student Dashboard')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Attendance'),
            subtitle: Text('View attendance (Coming Soon)'),
          ),
          ListTile(
            title: Text('Assignments'),
            subtitle: Text('Upcoming tasks (Coming Soon)'),
          ),
          ListTile(
            title: Text('Campus Map'),
            subtitle: Text('Find classrooms (Coming Soon)'),
          ),
        ],
      ),
    );
  }
}

/* ---------------- TEACHER DASHBOARD ---------------- */

class TeacherDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Dashboard')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('Raise Classroom Complaint'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ComplaintScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Take Attendance'),
            subtitle: Text('QR based (Next Week)'),
          ),
        ],
      ),
    );
  }
}

/* ---------------- COMPLAINT SCREEN ---------------- */

class ComplaintScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Raise Complaint')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Classroom'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Issue'),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Complaint Submitted')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
