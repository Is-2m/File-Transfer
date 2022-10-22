import 'dart:ui';

import 'package:file_transfer/Screens/add_task.dart';
import 'package:file_transfer/Screens/wrapper.dart';
import 'package:file_transfer/shared/operations.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    try {
      await SharedPreferences.getInstance().then((value) {
        Shared.preferences = value;
      });

      switch (taskName) {
        case "check":
          theMagic();
          break;
        default:
      }
    } catch (e) {
      print("catchedError: \n$e");
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) async {
    Shared.preferences = prefs;
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    var uniqueName = DateTime.now().millisecond.toString();
    Workmanager().registerPeriodicTask(uniqueName, "check");
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Shared.fetchTasks();
    theMagic();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'File Transfer',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff535353),
          secondary: const Color(0xffbdbdc7),
          tertiary: const Color(0xffe3e3e1),
        ),
      ),
      home: Wrapper(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return AddTask();
  }
}


