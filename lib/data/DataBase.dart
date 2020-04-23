import 'dart:async';

// Path помогает работать с директориями
import 'package:path/path.dart';
// Собственно, база данных на основе SQL
import 'package:sqflite/sqflite.dart';

/*
  Note упрощает нам жизнь, позволяя работать
  с экземпляром класса вместо словаря
*/
// Лучше назвать NoteModel
class Note {
  final int id;
  final String title;
  /*
    параметр id не обязателен,
    но title должен иметь значение
  */
  const Note({this.id, this.title = ''});
}

abstract class DataBase {
  static final fileName = 'notes_database.db';
  static final tableName = 'notes_table';

  // Инициализация базы данных
  // Лучше назвать getData
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), fileName),
      onCreate: (db, version) {
        return db.execute(
          '''
            CREATE TABLE $tableName (
              id INTEGER PRIMARY KEY,
              title TEXT
            )
          '''.trim().replaceAll(RegExp('\s+'), '\s'),
        );
      },
      version: 1
    );
  }

  // Два метода для конвертации модели
  static Map<String, dynamic> toMap(Note note) {
    return {
      'id': note.id,
      'title': note.title
    };
  }
  static Note fromMap(Map<String, dynamic> note) {
    return Note(id: note['id'], title: note['title']);
  }

  // Получение таблицы из базы
  // Лучше назвать getNotes
  static Future<List<Note>> notes() async {
    final Database data = await database();
    return (await data.query(tableName)).map(fromMap).toList();
  }

  // Создание новой заметки с ключом id = 0
  static Future<void> addNote(Note note) async {
    final db = await database();
    await db.insert(
      tableName,
      toMap(note),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // Обновление данных о заметке с ключом id = ?
  static Future<void> editNote(Note note) async {
    final db = await database();
    await db.update(
      tableName,
      toMap(note),
      where: 'id = ?',
      whereArgs: [note.id]
    );
  }
  // Удаления заметки из таблицы по ключу id = ?
  static Future<void> deleteNote(Note note) async {
    final db = await database();
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [note.id]
    );
  }
}
