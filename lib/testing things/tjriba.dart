import 'dart:convert';

import 'package:file_transfer/entities/Class_Task.dart';
import 'package:file_transfer/main.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tjriba extends StatefulWidget {
  Tjriba({Key? key}) : super(key: key);

  @override
  State<Tjriba> createState() => _TjribaState();
}

class _TjribaState extends State<Tjriba> { 
  late SharedPreferences _prefs;
  List tasks = [];
  @override
  void initState() {
    super.initState();
    _prefs = Shared.preferences!;
    _Njrbo();
  }

  _Njrbo() async {
    if (_prefs.containsKey("test") || _prefs.get('test') == null) {
      var kda = [
        new Task(
            id: 1,
            taskName: "name1",
            sourcePath: "source1",
            destPath: "dest1",
            transferMode: "mode1",
            taskState: true),
        new Task(
            id: 2,
            taskName: "name2",
            sourcePath: "source2",
            destPath: "dest2",
            transferMode: "mode1",
            taskState: true),
        new Task(
            id: 3,
            taskName: "name3",
            sourcePath: "source3",
            destPath: "dest3",
            transferMode: "mode1",
            taskState: true),
      ];
      _prefs.setString("teams", json.encode(kda));
      tasks = json.decode(_prefs.get('teams').toString());
    } else {
      tasks = json.decode(_prefs.get('teams').toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var a=Shared.test;
    a["value"]="tjriba";
    print("a: ${a.toString()}\ttest: ${Shared.test.toString()}");
    return Scaffold(
      body: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (BuildContext ctx, int i) {
            return Container(
                child: Text(tasks[i].toString()
                    ));
          }),
    );
  }
}
