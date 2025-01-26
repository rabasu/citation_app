import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/source_repository.dart';
import 'note_repository_provider.dart';

part 'source_repository_provider.g.dart';

@riverpod
SourceRepository sourceRepository(Ref ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return SourceRepository(dbHelper);
}
