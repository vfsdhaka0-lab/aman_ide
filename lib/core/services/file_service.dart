import 'dart:io';

class FileService {
  /// 📁 Base Path (REAL PHONE STORAGE)
  static const String basePath = "/storage/emulated/0/AmanIDE";

  /// 🚀 Initialize Storage Folder
  static Future<void> initStorage() async {
    final dir = Directory(basePath);

    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
  }

  ////////////////////////////////////////////////////////////
  /// 📁 PROJECT MANAGEMENT
  ////////////////////////////////////////////////////////////

  static Future<Directory> createProject(String name) async {
    final projectDir = Directory('$basePath/$name');

    if (!(await projectDir.exists())) {
      await projectDir.create(recursive: true);

      // Create lib folder
      await Directory('${projectDir.path}/lib').create();

      // Create main.dart
      await File('${projectDir.path}/lib/main.dart').writeAsString(
        '''void main() {
  print('Hello from Aman IDE 🚀');
}
''',
      );

      // Create pubspec.yaml
      await File('${projectDir.path}/pubspec.yaml').writeAsString(
        '''name: $name
description: Aman IDE project
version: 1.0.0

environment:
  sdk: ">=2.17.0 <4.0.0"
''',
      );
    }

    return projectDir;
  }

  static Future<List<FileSystemEntity>> listProjects() async {
    final dir = Directory(basePath);

    if (await dir.exists()) {
      return dir.listSync();
    }

    return [];
  }

  ////////////////////////////////////////////////////////////
  /// 📂 FILE & FOLDER MANAGEMENT
  ////////////////////////////////////////////////////////////

  static Future<List<FileSystemEntity>> listFiles(String path) async {
    final dir = Directory(path);

    if (await dir.exists()) {
      return dir.listSync();
    }

    return [];
  }

  static Future<void> createFile(String path, String name) async {
    final file = File('$path/$name');

    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
  }

  static Future<void> createFolder(String path, String name) async {
    final dir = Directory('$path/$name');

    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
  }

  ////////////////////////////////////////////////////////////
  /// ✍️ FILE READ & WRITE
  ////////////////////////////////////////////////////////////

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

  ////////////////////////////////////////////////////////////
  /// ❌ DELETE
  ////////////////////////////////////////////////////////////

  static Future<void> deleteFile(String path) async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> deleteFolder(String path) async {
    final dir = Directory(path);

    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}