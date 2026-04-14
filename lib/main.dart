import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileService.initStorage();
  runApp(const AmanIDE());
}

class AmanIDE extends StatelessWidget {
  const AmanIDE({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ProjectScreen(),
    );
  }
}

////////////////////////////////////////////////////////////
/// FILE SERVICE (REAL STORAGE)
////////////////////////////////////////////////////////////

class FileService {
  static const String basePath = "/storage/emulated/0/AmanIDE";

  static Future<void> initStorage() async {
    final dir = Directory(basePath);
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
  }

  static Future<Directory> createProject(String name) async {
    final dir = Directory('$basePath/$name');

    if (!(await dir.exists())) {
      await dir.create(recursive: true);

      await Directory('${dir.path}/lib').create();

      File('${dir.path}/lib/main.dart').writeAsStringSync(
        "void main() {\n  print('Hello Aman IDE');\n}",
      );

      File('${dir.path}/pubspec.yaml').writeAsStringSync(
        "name: $name\ndescription: Aman IDE project",
      );
    }

    return dir;
  }

  static Future<List<FileSystemEntity>> listFiles(String path) async {
    final dir = Directory(path);
    if (await dir.exists()) {
      return dir.listSync();
    }
    return [];
  }

  static Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
  }

  static Future<String> readFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }
}

////////////////////////////////////////////////////////////
/// PROJECT SCREEN
////////////////////////////////////////////////////////////

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<String> projects = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    await Permission.manageExternalStorage.request();
    loadProjects();
  }

  void loadProjects() async {
    final list = await FileService.listFiles(FileService.basePath);

    setState(() {
      projects = list.map((e) => e.path.split('/').last).toList();
    });
  }

  void createNewProject() async {
    await FileService.createProject("MyProject");
    loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aman IDE Projects"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: createNewProject,
          )
        ],
      ),
      body: ListView(
        children: projects.map((project) {
          return ListTile(
            title: Text(project),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditorScreen(projectPath: project),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// EDITOR SCREEN
////////////////////////////////////////////////////////////

class EditorScreen extends StatefulWidget {
  final String projectPath;

  const EditorScreen({super.key, required this.projectPath});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  String currentFilePath = "";
  String currentFileName = "";
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String projectFullPath =
        "${FileService.basePath}/${widget.projectPath}/lib";

    return Scaffold(
      appBar: AppBar(
        title: Text(currentFileName.isEmpty
            ? widget.projectPath
            : currentFileName),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (currentFilePath.isNotEmpty) {
                await FileService.writeFile(
                    currentFilePath, controller.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("File Saved")),
                );
              }
            },
          )
        ],
      ),
      body: Row(
        children: [
          /// 📁 FILE EXPLORER
          Container(
            width: 140,
            color: Colors.grey[900],
            child: FutureBuilder(
              future: FileService.listFiles(projectFullPath),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var files = snapshot.data as List<FileSystemEntity>;

                return ListView(
                  children: files.map((file) {
                    String name = file.path.split('/').last;

                    return ListTile(
                      title: Text(name),
                      onTap: () async {
                        String content =
                            await FileService.readFile(file.path);

                        setState(() {
                          currentFileName = name;
                          currentFilePath = file.path;
                          controller.text = content;
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),

          /// ✍️ CODE EDITOR
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.black,
              child: TextField(
                controller: controller,
                maxLines: null,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}