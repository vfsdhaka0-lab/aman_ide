import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileService {
  static Future<String> getBasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> getFile(String fileName) async {
    final path = await getBasePath();
    return File('$path/$fileName');
  }

  static Future<void> writeFile(String fileName, String content) async {
    final file = await getFile(fileName);
    await file.writeAsString(content);
  }

  static Future<String> readFile(String fileName) async {
    final file = await getFile(fileName);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }
}