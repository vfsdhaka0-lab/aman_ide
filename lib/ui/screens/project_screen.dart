import 'package:flutter/material.dart';
import '../../core/services/file_service.dart';
import 'editor_screen.dart';

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
    loadProjects();
  }

  void loadProjects() async {
    final base = await FileService.getBasePath();
    final list = await FileService.listFiles(base);

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