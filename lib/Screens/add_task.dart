import 'package:file_transfer/testing_things/Test1.dart';
import 'package:file_transfer/Screens/task_edit.dart';
import 'package:file_transfer/shared/operations.dart';
import 'package:file_transfer/testing_things/tjriba.dart';
import 'package:file_transfer/entities/Class_Task.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:file_transfer/util/Navigator.dart';
import 'package:file_transfer/widgets/detailed_task.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theMagic();
  }

  @override
  Widget build(BuildContext context) {
    // Shared.fetchTasks();
    // int("watchers:$watchers");
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigate.pushPage(context, EditTask());
              },
            ),
            onTap: () {
              // Fluttertoast.showToast(msg: "InkWell clicked",);
            },
          ),
          InkWell(
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigate.pushPage(context, Test1());
              },
            ),
          ),
        ],
      ),
      body: Shared.Tasks.isEmpty
          ? Container(
              margin: const EdgeInsets.all(10),
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey, offset: Offset(0, 1), blurRadius: 6)
                  ]),
              // color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      Navigate.pushPage(context, EditTask());
                    },
                    elevation: 2,
                    fillColor: Colors.amber,
                    child: const Icon(
                      Icons.add,
                      size: 35,
                    ),
                    padding: const EdgeInsets.all(5),
                    shape: const CircleBorder(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Add New Task",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ))
          : ListView.builder(
              itemCount: Shared.Tasks.length,
              itemBuilder: ((context, i) {
                return DetailedTask(task: Shared.Tasks[i]);
              })),
    );
  }
}
