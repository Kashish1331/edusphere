import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(EduSphere());
}

class EduSphere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "EduSphere",
      theme: ThemeData(
        fontFamily: "Roboto",
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

/* ---------------- SPLASH (ANIMATED) ---------------- */

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset("assets/logo.png", width: 140),

              SizedBox(height: 30),

              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'EduSphere',
                    textStyle: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: Duration(milliseconds: 120),
                  ),
                ],
                totalRepeatCount: 1,
              ),

              SizedBox(height: 10),

              AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText(
                    'Smart Campus Companion',
                    textStyle: TextStyle(
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
    );
  }
}

/* ---------------- LOGIN ---------------- */

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 20)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Welcome Back",
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),

                SizedBox(height: 25),

                TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                ),

                SizedBox(height: 15),

                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                  ),
                ),

                SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Color(0xff6A5AE0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text("LOGIN",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RoleSelection()));
                    },
                  ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Role"),
        backgroundColor: Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            roleCard(context, "Student", Icons.school, StudentDashboard()),
            SizedBox(height: 20),
            roleCard(context, "Teacher", Icons.person, TeacherDashboard()),
          ],
        ),
      ),
    );
  }

  Widget roleCard(BuildContext context, String text,
      IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(width: 20),
            Text(text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))
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
      appBar: AppBar(
        title: Text("Student Dashboard"),
        backgroundColor: Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            premiumCard(Icons.check_circle, "Attendance"),
            premiumCard(Icons.assignment, "Assignments"),
            premiumCard(Icons.map, "Campus Map"),
          ],
        ),
      ),
    );
  }

  Widget premiumCard(IconData icon, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xff6A5AE0), size: 30),
          SizedBox(width: 20),
          Text(text,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
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
      appBar: AppBar(
        title: Text("Teacher Dashboard"),
        backgroundColor: Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            premiumTapCard(context,
                Icons.report_problem,
                "Raise Complaint",
                ComplaintScreen()),
            premiumTapCard(context,
                Icons.qr_code,
                "QR Attendance (Soon)",
                null),
          ],
        ),
      ),
    );
  }

  Widget premiumTapCard(BuildContext context,
      IconData icon, String text, Widget? screen) {
    return GestureDetector(
      onTap: screen == null
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => screen)),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10)
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: Color(0xff6A5AE0),
                size: 30),
            SizedBox(width: 20),
            Text(text,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/* ---------------- COMPLAINT ---------------- */

class ComplaintScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Raise Complaint"),
        backgroundColor: Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Classroom",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide:
                        BorderSide.none),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: "Issue",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide:
                        BorderSide.none),
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.all(16),
                  backgroundColor:
                      Color(0xff6A5AE0),
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(14)),
                ),
                child: Text("SUBMIT"),
                onPressed: () {
                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Complaint Submitted")));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
