import 'dart:convert';
import 'dart:developer';

import 'package:file_transfer/entities/Class_Task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static var Tasks = new List<Task>.empty(growable: true);
  static SharedPreferences? preferences;
  static bool allGranted=false;

  static void fetchTasks() {
    if (preferences!.containsKey("tasks") && preferences!.get("tasks") != null) {
      if (Tasks.isNotEmpty) {
        Tasks = new List<Task>.empty(growable: true);
      }
      (json.decode(preferences!.get('tasks').toString())).forEach((element) {
        Tasks.add(Task.fromJson(element));
      });
    }
  }

  static void pushTasksToCache() {
    preferences!.setString("tasks", json.encode(Tasks));
  }

  static var test = {"id": 1, "value": "kda"};
}
