import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/repositories/folder_repository.dart';
import 'note_repository_provider.dart';

part 'folder_repository_provider.g.dart';

@riverpod
FolderRepository folderRepository(FolderRepositoryRef ref) {
  final dbHelper = ref.watch(dbHelperProvider);
  return FolderRepository(dbHelper);
}
