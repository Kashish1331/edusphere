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
  final deptController = TextEditingController();
  final passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  String role = "student";
  int semester = 1;

  String specialization = "None";

  Future<void> signUp() async {

    String email;

    if (role == "student") {
      email = "${rollController.text}@student.edusphere.app";
    } else {
      email = "${teacherController.text}@teacher.edusphere.app";
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
        'department': deptController.text,
        'semester': semester,
        'specialization': semester >= 3 ? specialization : "None"
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account Created Successfully")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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

              TextField(
                controller: deptController,
                decoration: const InputDecoration(labelText: "Department"),
              ),

              const SizedBox(height: 10),

              /// Semester dropdown
              DropdownButtonFormField<int>(
                value: semester,
                decoration: const InputDecoration(labelText: "Semester"),
                items: List.generate(
                  8,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text("Semester ${index + 1}"),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    semester = value!;
                  });
                },
              ),

              const SizedBox(height: 10),

              /// Specialization only if semester >=3
              if (semester >= 3)
                DropdownButtonFormField(
                  value: specialization,
                  decoration: const InputDecoration(labelText: "Specialization"),
                  items: const [

                    DropdownMenuItem(
                        value: "None",
                        child: Text("None (First Year)")),

                    DropdownMenuItem(
                        value: "AI",
                        child: Text("Artificial Intelligence")),

                    DropdownMenuItem(
                        value: "Data Science",
                        child: Text("Data Science")),

                    DropdownMenuItem(
                        value: "Cyber Security",
                        child: Text("Cyber Security")),

                    DropdownMenuItem(
                        value: "Full Stack",
                        child: Text("Full Stack Development")),

                    DropdownMenuItem(
                        value: "Blockchain",
                        child: Text("Blockchain")),

                    DropdownMenuItem(
                        value: "Game Development",
                        child: Text("Game Development")),

                    DropdownMenuItem(
                        value: "CSE Core",
                        child: Text("CSE Core")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      specialization = value!;
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