import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../data/db/db_helper.dart';
import '../data/repositories/note_repository.dart';

part 'note_repository_provider.g.dart';

@riverpod
DBHelper dbHelper(Ref ref) => DBHelper(databaseFactory: databaseFactory);

@riverpod
NoteRepository noteRepository(Ref ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return NoteRepository(dbHelper);
}
