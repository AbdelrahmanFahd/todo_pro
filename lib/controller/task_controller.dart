import 'package:get/get.dart';
import 'package:todo_pro_app/models/task.dart';

import '../db/database.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({required Task task}) async {
    return await DatabaseHelper().insertTask(task);
  }

  Future<List<Task>?> getTaskOfDay() async {
    return await DatabaseHelper().getData();
  }

  Future<void> delete(int id) async {
    await DatabaseHelper().deleteTask(id);
  }

  Future<void> updateTaskState(int id) async {
    await DatabaseHelper().updateTaskState(id);
  }
}
