// ignore_for_file: unnecessary_const

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_transfer/Screens/add_task.dart';
import 'package:file_transfer/entities/Class_Task.dart';
import 'package:file_transfer/shared/operations.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:file_transfer/util/Navigator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class EditTask extends StatefulWidget {
  EditTask({Key? key, this.id}) : super(key: key);
  int? id = 0;
  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  String sourcePath = "";
  String destPath = "";
  String name = "";
  bool state = true;
  bool isEdited = false;

  // Future askPermission() async {
  //   var storage = await Permission.storage.status;
  //   var externStor = await Permission.manageExternalStorage.status;
  //   if (storage.isDenied) {
  //     await Permission.storage.request();
  //   }
  //   if (externStor.isDenied) {
  //     await Permission.manageExternalStorage.request();
  //   }
  // }

  Future<String?> selectFolder() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  void initState() {
    super.initState();

    if (widget.id != 0 && widget.id != null) {
      currentTask =
          Shared.Tasks.firstWhere((element) => element.id == widget.id);
    }
  }

  Task? currentTask;

  @override
  Widget build(BuildContext context) {
    if (currentTask != null && !isEdited) {
      state = currentTask!.taskState!;
      name = currentTask!.taskName!;
      sourcePath = currentTask!.sourcePath!;
      destPath = currentTask!.destPath!;
      isEdited = true;
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(actions: [
            InkWell(
                child: IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (widget.id == 0 || widget.id == null) {
                  var task = new Task(
                      id: DateTime.now().millisecond,
                      taskName: name,
                      destPath: destPath,
                      sourcePath: sourcePath,
                      transferMode: "move",
                      taskState: state);
                  Shared.Tasks.add(task);
                } else {
                  currentTask!.taskName = name;
                  currentTask!.destPath = destPath;
                  currentTask!.sourcePath = sourcePath;
                  currentTask!.taskState = state;
                }
                Shared.pushTasksToCache();
                theMagic();
                Navigate.pushPageReplacement(context, AddTask());
                // Shared.fetchTasks();
              },
            ))
          ]),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        initialValue: name,
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: "Name"),
                      ),
                    ),
                    Switch(
                        value: state,
                        onChanged: (st) {
                          setState(() {
                            state = !state;
                          });
                        }),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(color: Colors.black54)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextButton(
                            onPressed: () {
                              // askPermission();
                              selectFolder().then((value) {
                                sourcePath = value!;
                                setState(() {});
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Source Path:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(sourcePath),
                              ],
                            )),
                        TextButton(
                            onPressed: () {
                              // askPermission();
                              selectFolder().then((value) {
                                destPath = value!;
                                setState(() {});
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Destination Path:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Text(destPath),
                              ],
                            )),
                      ]),
                ),
              )
            ],
          )),
    );
  }
}
