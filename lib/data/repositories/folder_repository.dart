import '../db/db_helper.dart';
import '../models/folder.dart';

class FolderRepository {
  final DBHelper _dbHelper;

  FolderRepository(this._dbHelper);

  Future<Folder> insert(Folder folder) async {
    final db = await _dbHelper.database;
    final id = await db.insert('folders', {
      'name': folder.name,
      'parent_id': folder.parentId,
      'color': folder.color,
    });
    return (await getById(id))!;
  }

  Future<List<Folder>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'folders',
      where: 'deleted_at IS NULL',
    );
    return List.generate(maps.length, (i) => Folder.fromDB(maps[i]));
  }

  Future<Folder?> getById(int id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'folders',
      where: 'id = ? AND deleted_at IS NULL',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Folder.fromDB(maps.first);
  }

  Future<List<Folder>> getByParentId(int? parentId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'folders',
      where: 'parent_id = ? AND deleted_at IS NULL',
      whereArgs: [parentId],
    );
    return List.generate(maps.length, (i) => Folder.fromDB(maps[i]));
  }

  Future<int> update(Folder folder) async {
    final db = await _dbHelper.database;
    final updateFolder = folder.copyWith(updatedAt: DateTime.now());
    return await db.update(
      'folders',
      Folder.toDB(updateFolder),
      where: 'id = ?',
      whereArgs: [folder.id],
    );
  }

  // 論理削除
  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    final values = <String, dynamic>{
      "deleted_at": DateTime.now().toIso8601String(),
    };
    return await db.update(
      'folders',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
