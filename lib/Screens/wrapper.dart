import 'package:file_transfer/Screens/add_task.dart';
import 'package:file_transfer/Screens/permissions_screen.dart';
import 'package:file_transfer/main.dart';
import 'package:file_transfer/shared/operations.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Shared.allGranted ? AddTask() : PermissionScreen();
  }
}
