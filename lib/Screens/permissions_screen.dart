import 'package:file_transfer/Screens/wrapper.dart';
import 'package:file_transfer/shared/shared.dart';
import 'package:file_transfer/util/Navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late PermissionStatus storage;
  late PermissionStatus media;
  late PermissionStatus externStor;
  late PermissionStatus battery;
  bool doneFetching = false;

  Future<bool> permissions() async {
    storage = await Permission.storage.status;
    media = await Permission.accessMediaLocation.status;
    externStor = await Permission.manageExternalStorage.status;
    battery = await Permission.ignoreBatteryOptimizations.status;
    doneFetching = true;
    return true;
  }

  void checkPermissions() {
    if (storage.isGranted && media.isGranted && battery.isGranted ||
        storage.isGranted &&
            media.isGranted &&
            battery.isGranted &&
            externStor.isGranted) {
      Shared.preferences!.setBool("allGranted", true);
      Shared.allGranted = true;
      Navigator.of(context)
      .pushAndRemoveUntil(
          PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) =>
                  Wrapper()),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    permissions().then((value) {
      doneFetching = value;
      checkPermissions();
      setState(() {});
    });
    return Scaffold(
      appBar: AppBar(),
      body: !doneFetching
          ? SpinKitCircle(
              color: Colors.grey,
              size: 70,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Access Media Permission",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Switch(
                            value: media.isGranted,
                            onChanged: (val) async {
                              await Permission.accessMediaLocation
                                  .request()
                                  .then((value) {
                                setState(() {});
                              });
                            })
                      ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Storage Permission",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Switch(
                            value: storage.isGranted,
                            onChanged: (val) async {
                              await Permission.storage.request().then((value) {
                                setState(() {});
                              });
                            })
                      ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Manage Storage Permission",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Switch(
                            value: externStor.isGranted,
                            onChanged: (val) async {
                              await Permission.manageExternalStorage
                                  .request()
                                  .then((value) {
                                setState(() {});
                              });
                            })
                      ]),
                ),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(color: Colors.black38),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Ignore Battery Optimization",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        Switch(
                            value: battery.isGranted,
                            onChanged: (val) async {
                              await Permission.ignoreBatteryOptimizations
                                  .request()
                                  .then((value) {
                                setState(() {});
                              });
                            })
                      ]),
                )
              ],
            ),
    );
  }
}
