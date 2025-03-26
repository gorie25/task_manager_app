import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller/task_controller.dart';
import 'package:task_manager_app/models/task.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Task task;
  const UpdateTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskController _taskController = Get.find();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dueDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _dueDateController = TextEditingController(text: widget.task.dueDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa công việc',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Công việc'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên công việc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả công việc';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(
                  labelText: 'Hạn hoàn thành',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    _dueDateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn hạn hoàn thành';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final task = Task(
                      id: widget.task.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      status: widget.task.status,
                      dueDate: _dueDateController.text,
                    );
                    _taskController.updateTask(task);
                    Navigator.pop(context);
                  },
                  child: const Text('Cập nhật công việc'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}