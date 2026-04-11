import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {

  final TextEditingController controller = TextEditingController();

  List<Map<String, String>> messages = [];

  Future<void> askAI(String question) async {
  const apiKey = "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";

  try {
    final response = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://edusphere.app", 
        "X-Title": "EduSphere AI"
      },
      body: jsonEncode({
        "model": "openrouter/auto",
        "messages": [
          {"role": "user", "content": question}
        ]
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final reply = data["choices"][0]["message"]["content"];

      setState(() {
        messages.add({"role": "ai", "text": reply});
      });
    } else {
      setState(() {
        messages.add({"role": "ai", "text": "Error: ${data["error"]["message"]}"});
      });
      print(data);
    }
  } catch (e) {
    setState(() {
      messages.add({"role": "ai", "text": "Connection error. Please try again."});
    });
    print(e);
  }
}

  Widget chatBubble(Map<String, String> msg) {

    bool isUser = msg["role"] == "user";

    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Text(
          msg["text"] ?? "",
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("EduSphere AI Assistant"),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return chatBubble(messages[index]);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.send),

                  onPressed: () {

                    final text = controller.text.trim();

                    if (text.isEmpty) return;

                    setState(() {
                      messages.add({"role": "user", "text": text});
                    });

                    controller.clear();

                    askAI(text);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}