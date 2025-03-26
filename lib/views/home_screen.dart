import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_manager_app/controller/task_controller.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/views/task_screen.dart';
import 'package:task_manager_app/views/update_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = GetStorage();
  final isActiveFilter = false.obs;
  final isDarkMode = false.obs;
  final TaskController _taskController = Get.find();
  final _searchController = TextEditingController();
  final searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    _taskController.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Quản lí công việc',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ))),
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Switch(
                      value: isDarkMode.value,
                      onChanged: (value) {
                        isDarkMode.value = value;
                        Get.changeThemeMode(
                            value ? ThemeMode.dark : ThemeMode.light);
                        box.write('isDarkMode', value);
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => searchQuery.value = value,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm công việc...",
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _taskController
                                  .searchTasks(_searchController.text);
                            },
                            child: Icon(Icons.search, color: Colors.grey)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal:
                                16.0), // Điều chỉnh khoảng cách cho các cạnh trái/phải
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    width: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        if (isActiveFilter.value == false) {
                          isActiveFilter.value = true;
                          _taskController.filterPendingTasks();
                        } else {
                          isActiveFilter.value = false;
                          _taskController.fetchTasks();
                        }
                      },
                      child: Text(
                        isActiveFilter.value ? 'Tất cả' : 'Lọc',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _taskController.tasks.length,
                itemBuilder: (context, index) {
                  Task task = _taskController.tasks[index];
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      if (task.id != null) {
                        _taskController.deleteTask(task.id!);
                      }
                    },
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: const Text("Xác nhận")),
                            content: const Text(
                                "Bạn có chắn chắn muốn xóa Task này?"),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text("Xóa"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Hủy"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.0),
                    ),
                    key: Key(task.id.toString()),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 6.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: (task.status == 1)
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(task.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    shape: CircleBorder(),
                                    activeColor: Theme.of(context).primaryColor,
                                    value: task.status == 1,
                                    visualDensity: const VisualDensity(
                                        horizontal: -4, vertical: -4),
                                    onChanged: (bool? value) {
                                      task.status = value! ? 1 : 0;
                                      _taskController.updateTaskStatus(task);
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Get.to(() => UpdateTaskScreen(task: task));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => TaskScreen());
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
