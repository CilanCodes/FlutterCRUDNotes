// lib/helpers/note_dao.dart
import 'package:flutter_crud_notes/models/note_model.dart';
import 'package:flutter_crud_notes/services/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteDao {
  Future<int> addNote(Note note) async {
    final db = await DatabaseHelper.getNoteDB();
    return await db.insert(
      "Note",
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateNote(Note note) async {
    final db = await DatabaseHelper.getNoteDB();
    return await db.update(
      "Note",
      note.toJson(),
      where: "id =?",
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteNote(Note note) async {
    final db = await DatabaseHelper.getNoteDB();
    return await db.delete(
      "Note",
      where: "id =?",
      whereArgs: [note.id],
    );
  }

  Future<List<Note>?> getAllNotes() async {
    final db = await DatabaseHelper.getNoteDB();
    final List<Map<String, dynamic>> notes = await db.query("Note");

    if (notes.isEmpty) return null;

    return List.generate(
      notes.length,
      (index) => Note.fromJson(notes[index]),
    );
  }
}
