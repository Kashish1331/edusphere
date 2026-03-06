import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeePortalScreen extends StatefulWidget {
  const FeePortalScreen({super.key});

  @override
  State<FeePortalScreen> createState() => _FeePortalScreenState();
}

class _FeePortalScreenState extends State<FeePortalScreen> {

  final supabase = Supabase.instance.client;

  int tuition = 0;
  int hostel = 0;
  int exam = 0;
  int sports = 0;
  int other = 0;

  bool hostelEnabled = true;

  String department = "";
  String semester = "";

  @override
  void initState() {
    super.initState();
    loadFees();
  }

  Future loadFees() async {

    final user = supabase.auth.currentUser;

    final userData = await supabase
        .from('users')
        .select()
        .eq('id', user!.id)
        .single();

    department = userData['department'];
    semester = userData['semester'];

    final feeData = await supabase
        .from('fees')
        .select()
        .eq('department', department)
        .eq('semester', semester)
        .single();

    setState(() {
      tuition = feeData['tuition_fee'];
      hostel = feeData['hostel_fee'];
      exam = feeData['exam_fee'];
      sports = feeData['sports_fee'];
      other = feeData['other_fee'];
    });
  }

  Widget feeTile(String title, int amount, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 6,
          )
        ],
      ),
      child: Row(
        children: [

          Icon(icon, color: const Color(0xff6A5AE0)),

          const SizedBox(width: 15),

          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 16)),
          ),

          Text(
            "₹ $amount",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    int total = tuition + exam + sports + other;

    if (hostelEnabled) {
      total += hostel;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fee Portal"),
        backgroundColor: const Color(0xff6A5AE0),
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// NOTE BOX
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Note: If you are not opting for hostel accommodation you may disable the hostel fee below.",
                style: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),

            /// HOSTEL SWITCH
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 5,
                  )
                ],
              ),
              child: SwitchListTile(
                value: hostelEnabled,
                activeColor: const Color(0xff6A5AE0),
                title: const Text("Hostel Accommodation"),
                onChanged: (value) {
                  setState(() {
                    hostelEnabled = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 25),

            /// FEES BREAKDOWN
            feeTile("Tuition Fee", tuition, Icons.school),

            if (hostelEnabled)
              feeTile("Hostel Fee", hostel, Icons.apartment),

            feeTile("Exam Fee", exam, Icons.description),

            feeTile("Sports Fee", sports, Icons.sports_soccer),

            feeTile("Other Charges", other, Icons.receipt),

            const SizedBox(height: 25),

            /// TOTAL CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff6A5AE0), Color(0xff8FD3FE)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Total Fee",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),

                  Text(
                    "₹ $total",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}