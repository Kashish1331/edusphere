import 'package:flutter/material.dart';
import 'attendance_screen.dart';

class StudentHome extends StatefulWidget {
  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
  StudentDashboard(),
  AttendanceScreen(),
  CampusMapScreen(),
  StudentProfileScreen(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xff6A5AE0),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
