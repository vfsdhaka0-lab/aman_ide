import 'package:flutter/material.dart';

void main() {
  runApp(const AmanIDE());
}

class AmanIDE extends StatelessWidget {
  const AmanIDE({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aman IDE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const EditorScreen(),
    );
  }
}

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String currentFile = "main.dart";
  String code = "// Start coding here...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aman IDE - $currentFile"),
      ),
      body: Row(
        children: [
          // 📁 File Explorer
          Container(
            width: 120,
            color: Colors.grey[900],
            child: ListView(
              children: [
                ListTile(
                  title: const Text("main.dart"),
                  onTap: () {
                    setState(() {
                      currentFile = "main.dart";
                      code = "// main.dart file";
                    });
                  },
                ),
                ListTile(
                  title: const Text("home.dart"),
                  onTap: () {
                    setState(() {
                      currentFile = "home.dart";
                      code = "// home.dart file";
                    });
                  },
                ),
              ],
            ),
          ),

          // ✍️ Code Editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black,
              child: TextField(
                controller: TextEditingController(text: code),
                maxLines: null,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  code = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}