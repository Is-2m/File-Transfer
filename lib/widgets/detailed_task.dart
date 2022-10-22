import 'dart:convert';
import 'dart:developer';

import 'package:file_transfer/Screens/add_task.dart';
import 'package:file_transfer/Screens/task_edit.dart';
import 'package:file_transfer/entities/Class_Task.dart';
import 'package:file_transfer/shared/operations.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:file_transfer/util/Navigator.dart';
import 'package:flutter/material.dart';

class DetailedTask extends StatefulWidget {
  DetailedTask({Key? key, required this.task}) : super(key: key);
  Task task;
  @override
  State<DetailedTask> createState() => _DetailedTaskState();
}

class _DetailedTaskState extends State<DetailedTask> {
  double height = 60;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: const [
              BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 6)
            ]),
        // color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.95,
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          onExpansionChanged: (isExpanded) => setState(() {
            height = isExpanded ? 200 : 60;
          }),
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 30,
              ),
              // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right)),
              Text(
                widget.task.taskName!,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Switch(
                  value: widget.task.taskState!,
                  onChanged: (etat) {
                    setState(() {
                      widget.task.taskState = etat;
                      Shared.Tasks.firstWhere(
                              (element) => element.id == widget.task.id)
                          .taskState = etat;
                      Shared.pushTasksToCache();
                      theMagic();
                    });
                  })
            ],
          ),
          children: [
            Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Source Path:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(widget.task.sourcePath!),
                  Text(
                    "Destination Path:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(widget.task.destPath!),
                ],
              ),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    fixedSize: Size(150, 20),
                  ),
                  onPressed: () => Navigate.pushPage(
                      context,
                      EditTask(
                        id: widget.task.id,
                      )),
                  child: Text(
                    "EDIT",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    fixedSize: Size(90, 20),
                  ),
                  onPressed: () {
                    showAlertDialog(context, widget.task);
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ))
          ],
        ));
  }
}

showAlertDialog(BuildContext context, Task task) async {
  Widget cancelButton = TextButton(
    onPressed: () {
      Navigate.popPage(context);
    },
    child: Text("Cancel"),
  );
  Widget continueButton = TextButton(
    onPressed: () {
      Shared.Tasks.removeWhere((element) => element.id == task.id);
      Shared.pushTasksToCache();
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) =>
                  AddTask()),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero),
          (route) => false);
    },
    child: Text("Continue"),
  );
  AlertDialog alert = AlertDialog(
    title: Text("Deleting"),
    content: Text("Do you really wanna delete this?"),
    actions: [cancelButton, continueButton],
  );
  await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) => alert);
      });
}
