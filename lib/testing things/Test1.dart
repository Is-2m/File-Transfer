import 'dart:io';

import 'package:file_transfer/shared/operations.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:path_provider_ex/path_provider_ex.dart';
class Test1 extends StatefulWidget {
  const Test1({Key? key}) : super(key: key);

  @override
  State<Test1> createState() => _Test1State();
}

class _Test1State extends State<Test1> {
  @override
  void initState() {
    super.initState();
    Shared.fetchTasks();
    // fetchFiles(Shared.Tasks.first.sourcePath!);
  }

  Future askPermission() async {
    var storage = await Permission.storage.status;
    var media = await Permission.accessMediaLocation.status;
    var externStor = await Permission.manageExternalStorage.status;
    if (storage.isDenied) {
      await Permission.storage.request();
    }
    if (media.isDenied) {
      await Permission.accessMediaLocation.request();
    }
    if (externStor.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  List<File> files = [];

  void fetchFiles(String path) {
    Directory dir = new Directory(Shared.Tasks.first.destPath!);
    List<FileSystemEntity> files1 = dir.listSync();
    for (FileSystemEntity fileEntity in files1) {
      File file = fileEntity as File;
      print(file.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(files);
    fetchFiles("path");
    return Scaffold(
      appBar: AppBar(),

      // body: Column(
      //   children: [
      //     Text("data"),
      //     Expanded(
      //       child: ListView.builder(
      //           itemCount: files.length ,//?? 0,
      //           itemBuilder: (context, i) => Text(files[i].path)),
      //     ),
      //     ElevatedButton(
      //         onPressed: () {
      //           askPermission();
      //           Operations.moveFiles(files);
      //           fetchFiles(Shared.Tasks.first.destPath!);
      //         },
      //         child: Text("Click"))
      //   ],
      // ),
    );
  }
}
