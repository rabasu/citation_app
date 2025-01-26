import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  final DatabaseFactory databaseFactory;
  final String databaseName;

  DBHelper({
    required this.databaseFactory,
    this.databaseName = 'app_database.db',
  });

  Database? _database;

  // データベースへのアクセス
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  // データベース初期化
  Future<Database> initDatabase() async {
    final dbPath = await databaseFactory.getDatabasesPath();
    final path = join(dbPath, databaseName);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await createTables(db);
        },
      ),
    );
  }

  Future<String> getDbPath() async {
    var dbFilePath = '';

    final databaseFactory = databaseFactoryFfi;
    final dbPath = await databaseFactory.getDatabasesPath();
    final pathToDb = join(dbPath, 'test.db');

    return pathToDb;

    if (Platform.isAndroid) {
      // Androidであれば「getDatabasesPath」を利用
      dbFilePath = await databaseFactory.getDatabasesPath();
    } else if (Platform.isIOS) {
      // iOSであれば「getLibraryDirectory」を利用
      final dbDirectory = await getLibraryDirectory();
      dbFilePath = dbDirectory.path;
    } else {
      // プラットフォームが判別できない場合はExceptionをthrow
      // 簡易的にExceptionをつかったが、自作Exceptionの方がよいと思う。
      throw Exception('Unable to determine platform.');
    }
    // 配置場所のパスを作成して返却
    final path = join(dbFilePath, databaseName);
    return path;
  }

  // データベースを閉じる
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
  }

  Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        parent_id INTEGER,
        color TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        deleted_at TEXT,
        FOREIGN KEY (parent_id) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE sources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        url TEXT,
        description TEXT,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        deleted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT NOT NULL,
        source_id INTEGER,
        page TEXT,
        folder_id INTEGER,
        created_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        updated_at TEXT NOT NULL DEFAULT (DATETIME('now', 'localtime')),
        deleted_at TEXT,
        FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE,
        FOREIGN KEY (source_id) REFERENCES sources (id) ON DELETE SET NULL
      )
    ''');
  }
}
