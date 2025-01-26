import '../db/db_helper.dart';
import '../models/note.dart';

class NoteRepository {
  final DBHelper _dbHelper;

  NoteRepository(this._dbHelper);

  Future<Note> insert(Note note) async {
    final db = await _dbHelper.database;
    final id = await db.insert('notes', {
      'title': note.title,
      'content': note.content,
      'source_id': note.sourceId,
      'page': note.page,
      'folder_id': note.folderId,
    });
    return (await getById(id))!;
  }

  Future<List<Note>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'deleted_at IS NULL',
    );
    return List.generate(maps.length, (i) => Note.fromDB(maps[i]));
  }

  Future<Note?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Note.fromDB(maps.first);
  }

  Future<int> update(Note note) async {
    final db = await _dbHelper.database;
    final updateNote = note.copyWith(updatedAt: DateTime.now());
    return await db.update(
      'notes',
      Note.toDB(updateNote),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    final values = <String, dynamic>{
      "deleted_at": DateTime.now().toIso8601String(),
    };
    return await db.update(
      'notes',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> getByFolderId(int? folderId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: folderId == null ? 'folder_id IS NULL' : 'folder_id = ?',
      whereArgs: folderId == null ? null : [folderId],
    );
    return List.generate(maps.length, (i) => Note.fromDB(maps[i]));
  }

  Future<List<Note>> getBySourceId(int sourceId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'source_id = ? AND deleted_at IS NULL',
      whereArgs: [sourceId],
    );
    return List.generate(maps.length, (i) => Note.fromDB(maps[i]));
  }
}
