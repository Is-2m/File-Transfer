import 'dart:developer';
import 'dart:io';
import 'package:file_transfer/entities/Class_Task.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'package:file_transfer/shared/shared.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:watcher/watcher.dart';

List<DirectoryWatcher> watchers = List.empty(growable: true);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<File> moveFileByPath(
    {required String sourcePath, required String newPath}) async {
  File sourceFile = new File(sourcePath);
  try {
    return await sourceFile.rename(newPath);
  } on FileSystemException catch (e) {
    print("error1: $e");
    final newFile = await sourceFile.copy(newPath);
    if (await sourceFile.exists()) {
      await sourceFile.delete();
    }
    pushNotification(sourcePath);
    return newFile;
  }
}

Future<File?> moveFile(
    {required String sourcePath, required String newPath}) async {
  try {
    // Create the parent directory if it doesn't exist

    File sourceFile = File(sourcePath);
    final newFile = await createParentDirectoryAndRename(sourceFile, newPath);

    pushNotification(sourceFile.path);

    return newFile;
  } on FileSystemException catch (e) {
    print("error1: $e");
    File sourceFile = File(sourcePath);

    final newFile = await createParentDirectoryAndCopy(sourceFile, newPath);

    if (await sourceFile.exists()) {
      await sourceFile.delete();
      pushNotification(sourceFile.path);
    }

    return newFile;
  }
}

Future<File> createParentDirectoryAndRename(
    File sourceFile, String newPath) async {
  final newFile = File(newPath);
  final newDirectory = Directory(newFile.parent.path);

  if (!newDirectory.existsSync()) {
    await newDirectory.create(recursive: true);
  }

  await sourceFile.rename(newPath);

  return newFile;
}

Future<File> createParentDirectoryAndCopy(
    File sourceFile, String newPath) async {
  final newFile = File(newPath);
  final newDirectory = Directory(newFile.parent.path);

  if (!newDirectory.existsSync()) {
    await newDirectory.create(recursive: true);
  }

  await sourceFile.copy(newPath);

  return newFile;
}



List<File> fetchFiles(sourcePath) {
  Directory dir = new Directory(sourcePath);
  List<File> files = new List.empty(growable: true);
  for (FileSystemEntity file in dir.listSync()) {
    files.add(file as File);
  }
  return files;
}

void watchDirectory(Task task) {
  bool isFound = false;
  DirectoryWatcher? watcher;
  watchers.forEach((element) {
    element.path == task.sourcePath;
    isFound = true;
    watcher = element;
  });
  if (isFound) {
    watcher!.events.listen((event) {
      if (event == ChangeType.ADD) {
        String relativePath = event.path.substring(task.sourcePath!.length);
        String newPath = "${task.destPath}$relativePath";
        moveFile(sourcePath: event.path, newPath: newPath);
      }
    });
  } else {
    watchers.add(DirectoryWatcher(task.sourcePath!));
    watchers.last.events.listen((event) {
      if (event.type == ChangeType.ADD) {
        String relativePath = event.path.substring(task.sourcePath!.length);
        String newPath = "${task.destPath}$relativePath";
        moveFile(sourcePath: event.path, newPath: newPath);
        //'event.path' is the new full path to the new created/detected file
        //it's given as an argument cause i'll need to create File Object out of it
      }
    });
  }
}

void theMagic() {
  Shared.fetchTasks();
  var tasks = Shared.Tasks;
  tasks.forEach((task) {
    if (task.taskState!) {
      watchDirectory(task);
      checkAndMoveExistantFiles(task);
    }
  });
}

void checkAndMoveExistantFiles(Task task) {
  moveFilesRecursively(task.sourcePath!, task.destPath!);
}

void moveFilesRecursively(String sourcePath, String destPath) {
  Directory sourceDir = Directory(sourcePath);
  if (sourceDir.existsSync()) {
    sourceDir.listSync(recursive: true).forEach((FileSystemEntity entity) {
      if (entity is File) {
        String relativePath = entity.path.substring(sourcePath.length);
        String newPath = "$destPath$relativePath";
      
        moveFile(sourcePath: entity.path, newPath: newPath);
      }
    });
  }
}

pushNotification(String fileTransfered) {
  flutterLocalNotificationsPlugin.show(
    888,
    "File Transfered",
    'last: $fileTransfered',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_foreground',
        'MY FOREGROUND SERVICE',
        icon: 'ic_bg_service_small',
        ongoing: true,
      ),
    ),
  );
  print("copied: $fileTransfered");
}

Future<bool> askPermission() async {
  var storage = await Permission.storage.status;
  var media = await Permission.accessMediaLocation.status;
  // var externStor = await Permission.manageExternalStorage.status;
  var battery = await Permission.ignoreBatteryOptimizations.status;
  if (storage.isDenied) {
    await Permission.storage.request();
  }
  if (media.isDenied) {
    await Permission.accessMediaLocation.request();
  }
  // if (externStor.isDenied) {
  //   await Permission.manageExternalStorage.request();
  // }
  if (battery.isDenied) {
    await Permission.manageExternalStorage.request();
  }
  if (media.isGranted && storage.isGranted && battery.isGranted) {
    return true;
  } else {
    return false;
  }
}
