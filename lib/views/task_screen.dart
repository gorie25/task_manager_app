import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/controller/task_controller.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/db/database_helper.dart';
import 'package:task_manager_app/models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskController _taskController = Get.find();

  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  late TextEditingController _dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo công việc mới' ,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        )
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tên công việc',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên công việc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả công việc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Due Date Picker
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Hạn hoàn thành',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn hạn hoàn thành';
                  }
                  return null;
                },
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    _dueDateController.text =
                        DateFormat('dd/MM/yyyy').format(selectedDate);
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Task task = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      status: 0,
                      dueDate: _dueDateController.text,
                    );
                    _taskController.addTask(task);
                    _titleController.clear();
                    _descriptionController.clear();
                    _dueDateController.clear();
                  }
                },
                child: const Text('Tạo công việc mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
