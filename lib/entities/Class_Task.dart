class Task {
  int? id;
  String? taskName;
  String? sourcePath;
  String? destPath;
  String? transferMode;
  bool? taskState;

  Task( 
      {
      this.id,
      this.taskName,
      this.sourcePath,
      this.destPath,
      this.transferMode="move",
      this.taskState=true});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['task_name'];
    sourcePath = json['source_path'];
    destPath = json['dest_path'];
    transferMode = json['transfer_mode'];
    taskState = json['task_state'];
  }
  static Task dynamicToTask(dynamic dynamicTask){    
    Task task=new Task();
    task.id = dynamicTask['id'];
    task.taskName = dynamicTask['task_name'];
    task.sourcePath = dynamicTask['source_path'];
    task.destPath = dynamicTask['dest_path'];
    task.transferMode = dynamicTask['transfer_mode'];
    task.taskState = dynamicTask['task_state'];
    return task;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_name'] = this.taskName;
    data['source_path'] = this.sourcePath;
    data['dest_path'] = this.destPath;
    data['transfer_mode'] = this.transferMode;
    data['task_state'] = this.taskState;
    return data;
  }
}
