import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager_app/models/task.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, status INTEGER, due_date TEXT, created_at TEXT, updated_at TEXT)');
      },
    );
  }

  Future<int> insertTask(Task task) async {
    final db = await database; // Sử dụng getter
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks({bool onlyPending = false}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: onlyPending ? 'status = 0' : null,
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Task>> filterTasksByStatus(int status) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'status = $status',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<List<Task>> searchTasksByTitle(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }
}
