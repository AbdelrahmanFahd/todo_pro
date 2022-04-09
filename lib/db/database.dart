import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseHelper {
  //init the database
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'task.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('CREATE TABLE task (id INTEGER PRIMARY KEY, '
            'title TEXT, '
            'note TEXT, '
            'dateTime TEXT, '
            'startTime TEXT, '
            'endTime TEXT, '
            'repeat TEXT, '
            'color INTEGER, '
            'reminder INTEGER, '
            'isComplete INTEGER)');
      },
    );
  }

  //insert task
  Future<int> insertTask(Task task) async {
    final db = await database();

    return await db.insert('task', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //get data
  Future<List<Task>?> getData() async {
    // DateFormat.yMd().format(_selectedDate)
    final db = await database();

    List<Map<String, dynamic>> maps = await db.query('task');

    return List.generate(
        maps.length,
        ((index) => Task(
            id: maps[index]['id'],
            title: maps[index]['title'],
            note: maps[index]['note'],
            color: maps[index]['color'],
            dateTime: maps[index]['dateTime'],
            startTime: maps[index]['startTime'],
            endTime: maps[index]['endTime'],
            reminder: maps[index]['reminder'],
            repeat: maps[index]['repeat'],
            isComplete: maps[index]['isComplete'])));
  }

  //delete data
  Future<void> deleteTask(int taskId) async {
    final db = await database();
    await db.rawDelete(
      'DELETE FROM task WHERE id = $taskId',
    );
  }

  Future<void> updateTaskState(int taskId) async {
    final db = await database();
    await db.rawUpdate(
      'UPDATE task SET isComplete = 1 WHERE id = $taskId',
    );
  }
}

// 'title TEXT, '
// 'note TEXT, '
// 'dateTime TEXT, '
// 'startTime TEXT, '
// 'endTime TEXT, '
// 'repeat TEXT, '
// 'color INTEGER, '
// 'reminder INTEGER, '
// 'isComplete INTEGER)');
