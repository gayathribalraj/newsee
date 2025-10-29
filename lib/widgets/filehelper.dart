import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


// get localPath 
class FileHelper{
  static Future<String> localPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
// get localFile 

static Future<File> localFile(String filename) async {
    final path = await localPath();
    return File('$path/$filename');
  }

   static Future<void> writeLines(String filename, List<String> lines) async {
    final file = await localFile(filename);
    final contents = lines.join('\n');
    await file.writeAsString(contents, encoding: utf8, flush: true);
  }

   static Future<void> writeJson(String filename, dynamic data) async {
    final file = await localFile(filename);
    final jsonString = const JsonEncoder.withIndent(' ').convert(data);
    await file.writeAsString(jsonString, encoding: utf8, flush: true);
  }

 
}