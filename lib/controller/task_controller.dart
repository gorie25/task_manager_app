import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/db/database_helper.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var showPendingOnly = false.obs;
  var searchQuery = ''.obs;
  Future<void> addTask(Task task) async {
    try {
      task.createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      task.updatedAt = task.createdAt;
      await DatabaseHelper.instance.insertTask(task);
      fetchTasks();
      Get.snackbar(
        "Thành công",
        "Công việc đã được thêm!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Lỗi",
        "Không thể thêm công việc!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchTasks() async {
    tasks.value = await DatabaseHelper.instance
        .getTasks(onlyPending: showPendingOnly.value);
  }

  Future<void> deleteTask(int id) async {
    int result = await DatabaseHelper.instance.deleteTask(id);
    if (result > 0) {
      fetchTasks();
      Get.snackbar(
        "Xóa thành công",
        "Công việc đã được xóa!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Lỗi",
        "Không thể xóa công việc!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateTask(Task task) async {
    task.updatedAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    int result = await DatabaseHelper.instance.updateTask(task);
    if (result > 0) {
      fetchTasks();
      Get.snackbar(
        "Cập nhật thành công",
        "Công việc đã được cập nhật!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Lỗi",
        "Công việc chưa thể cập nhật!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateTaskStatus(Task task) async {
    task.updatedAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    int result = await DatabaseHelper.instance.updateTask(task);
    final db = await DatabaseHelper.instance.database;
    final rs = await db.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [task.id],
    );
    print('Task: $rs');

    if (result > 0) {
      fetchTasks();
      print('Cập nhật trạng thái công việc thành công!');
    } else {
      Get.snackbar(
        "Lỗi",
        "Không thể cập nhật trạng thái công việc!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> filterPendingTasks() async {
    final pendingTasks = await DatabaseHelper.instance.filterTasksByStatus(0);
    tasks.value = pendingTasks;
  }

  Future<void> searchTasks(String query) async {
    searchQuery.value = query;
    print('Search query: $query');
    if (query.isEmpty) {
      fetchTasks(); // Hiển thị toàn bộ danh sách khi query rỗng
    } else {
      tasks.value = await DatabaseHelper.instance.searchTasksByTitle(query);
      tasks.assignAll(
          tasks.where((task) => task.title!.contains(query)).toList());
    }
  }
}
