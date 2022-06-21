import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../data/models/event.dart';

class DatabaseHelper {
  final eventTable = 'my_events';

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'calendar.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $eventTable(
              id INTEGER PRIMARY KEY, 
              startTime TEXT, 
              endTime TEXT,
              subject TEXT,
              location TEXT,
              color INTEGER)
              ''');
        return db;
      },
      version: 1,
    );
  }

  Future<int> insert(Event event) async {
    Database db = await database();
    event.id = await db
        .insert(eventTable, event.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => event.id = value);
    return event.id;
  }

  Future<Event> getEvent(int id) async {
    Database db = await database();
    List<Map> maps = await db.query(eventTable,
        columns: ['id', 'startTime', 'endTime', 'subject', 'location', 'color'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Event.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Event>> getEvents() async {
    Database db = await database();
    List<Map<String, dynamic>> taskMap = await db.query(eventTable);
    return List.generate(taskMap.length, (index) {
      return Event(
        id: taskMap[index]['id'],
        startTime: taskMap[index]['startTime'],
        endTime: taskMap[index]['endTime'],
        subject: taskMap[index]['subject'],
        location: taskMap[index]['location'],
        color: taskMap[index]['color'],
      );
    });
  }

  Future<int> delete(int id) async {
    Database db = await database();
    return await db.delete(eventTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Event event) async {
    Database db = await database();
    return await db.update(eventTable, event.toMap(),
        where: 'id = ?', whereArgs: [event.id]);
  }

  Future close() async {
    Database db = await database();
    db.close();
  }
}
