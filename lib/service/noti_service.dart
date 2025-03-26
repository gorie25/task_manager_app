import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager_app/db/database_helper.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          Get.toNamed('/home');
        }
      },
    );

    try {
      tz.initializeTimeZones();
      debugPrint("Timezones initialized successfully.");
    } catch (e) {
      debugPrint("Error initializing timezones: $e");
    }
  }

Future<void> scheduleNotificationsFromTasks() async {
  List<Task> tasks = await DatabaseHelper.instance.getTasks();
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  for (Task task in tasks) {
    if (task.dueDate != null && task.status == 0) { // Chỉ thông báo task chưa hoàn thành
      DateTime taskDate = DateFormat("dd/MM/yyyy").parse(task.dueDate!);
      taskDate = DateTime(taskDate.year, taskDate.month, taskDate.day);

      if (taskDate.isAtSameMomentAs(today)) {
        // ✅ Task có hạn hôm nay, thông báo ngay lập tức
        BigTextStyleInformation bigTextStyle = BigTextStyleInformation(
          '${task.title}\n ${task.description ?? 'Hãy hoàn thành ngay!'}',
          contentTitle: '📌 Công việc hôm nay',
          summaryText: 'Nhấn vào để xem chi tiết!',
        );

        AndroidNotificationDetails androidNotificationDetails =
            AndroidNotificationDetails(
          'task_reminder', 'Nhắc nhở công việc',
          importance: Importance.max, // Thông báo quan trọng
          priority: Priority.high,
          ticker: 'task_ticker',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: bigTextStyle, // Hiển thị nội dung mở rộng
          color: Colors.blue, // Màu nền
          playSound: true, // Âm thanh thông báo
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
        );

        NotificationDetails notificationDetails =
            NotificationDetails(android: androidNotificationDetails);

        await _flutterLocalNotificationsPlugin.show(
          task.id!, // ID của task
          '📌 Công việc hôm nay',
          '${task.title}\n- ${task.description ?? 'Hãy hoàn thành ngay!'}',
          notificationDetails,
        );
      }
    }
  }
}


  /// Huỷ một thông báo theo ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Huỷ toàn bộ thông báo
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }


}
