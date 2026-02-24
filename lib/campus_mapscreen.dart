import 'package:flutter/material.dart';

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campus Map"),
        backgroundColor: const Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        child: Image.asset(
          'assets/campus.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}