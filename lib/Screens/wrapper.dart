import 'package:file_transfer/main.dart';
import 'package:file_transfer/shared/operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _allGranted = false;

  grantPermession() {
    askPermission().then((value) {
      _allGranted = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    grantPermession();
    if (_allGranted) {
      return MyHomePage();

    } else {
      return SpinKitCircle(
        color: Colors.grey,
        size: 70,
        
      );
    }
  }
}
