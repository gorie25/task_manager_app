import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller/task_controller.dart';
import 'package:task_manager_app/theme/theme.dart';
import 'package:task_manager_app/views/home_screen.dart';
import 'package:task_manager_app/service/noti_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().scheduleNotificationsFromTasks();
  Get.put(TaskController());
  runApp(MyApp(
    isDarkMode: false,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  MyApp({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
