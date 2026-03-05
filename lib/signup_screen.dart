import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final teacherController = TextEditingController();
  final passwordController = TextEditingController();

  String role = "student";
  String department = "CSE";

  final supabase = Supabase.instance.client;

  Future<void> signUp() async {
    try {
      String email;

      if (role == "student") {
        email = "${rollController.text.toLowerCase()}@student.edusphere.app";
      } else {
        email = "${teacherController.text.toLowerCase()}@teacher.edusphere.app";
      }

      final response = await supabase.auth.signUp(
        email: email,
        password: passwordController.text,
      );

      final user = response.user;

      if (user != null) {
        await supabase.from('users').insert({
          'id': user.id,
          'name': nameController.text,
          'email': email,
          'role': role,
          'roll_number': role == "student" ? rollController.text : null,
          'teacher_id': role == "teacher" ? teacherController.text : null,
          'department': department,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Created Successfully")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),

              const SizedBox(height: 10),

              DropdownButtonFormField(
                value: role,
                items: const [
                  DropdownMenuItem(value: "student", child: Text("Student")),
                  DropdownMenuItem(value: "teacher", child: Text("Teacher")),
                ],
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              if (role == "student")
                TextField(
                  controller: rollController,
                  decoration: const InputDecoration(labelText: "Roll Number"),
                ),

              if (role == "teacher")
                TextField(
                  controller: teacherController,
                  decoration: const InputDecoration(labelText: "Teacher ID"),
                ),

              const SizedBox(height: 10),

              /// Department Dropdown
              DropdownButtonFormField(
                value: department,
                decoration: const InputDecoration(labelText: "Department"),
                items: const [
                  DropdownMenuItem(value: "CSE", child: Text("CSE")),
                  DropdownMenuItem(value: "AI", child: Text("AI")),
                  DropdownMenuItem(value: "ECE", child: Text("ECE")),
                  DropdownMenuItem(value: "MBA", child: Text("MBA")),
                  DropdownMenuItem(value: "LAW", child: Text("LAW")),
                  DropdownMenuItem(value: "BBA", child: Text("BBA")),
                ],
                onChanged: (value) {
                  setState(() {
                    department = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: signUp,
                child: const Text("Create Account"),
              )
            ],
          ),
        ),
      ),
    );
  }
}