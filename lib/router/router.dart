import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/views/home_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String task = '/task';

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () => HomeScreen(),
    ),
    // GetPage(
    //   name: task,
    //   page: () => TaskScreen(),
    // ),
  ];
}
