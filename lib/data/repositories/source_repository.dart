import '../db/db_helper.dart';
import '../models/source.dart';

class SourceRepository {
  final DBHelper _dbHelper;

  SourceRepository(this._dbHelper);

  Future<Source> insert(Source source) async {
    final db = await _dbHelper.database;
    final id = await db.insert('sources', {
      'title': source.title,
      'url': source.url,
      'description': source.description,
    });
    return (await getById(id))!;
  }

  Future<List<Source>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sources',
      where: 'deleted_at IS NULL',
    );
    return List.generate(maps.length, (i) => Source.fromDB(maps[i]));
  }

  Future<Source?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sources',
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Source.fromDB(maps.first);
  }

  Future<int> update(Source source) async {
    final db = await _dbHelper.database;
    return await db.update(
      'sources',
      Source.toDB(source),
      where: 'id = ?',
      whereArgs: [source.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    final values = <String, dynamic>{
      "deleted_at": DateTime.now().toIso8601String(),
    };
    return await db.update(
      'sources',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
