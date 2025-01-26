import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/folder.dart';
import 'folder_repository_provider.dart';

part 'folder_list_provider.g.dart';

@riverpod
class FolderList extends _$FolderList {
  @override
  Future<List<Folder>> build([int? folderId]) async {
    final repository = ref.watch(folderRepositoryProvider);
    return repository.getByParentId(folderId);
  }

  Future<void> refresh(int? folderId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(folderRepositoryProvider).getByParentId(folderId));
  }

  Future<void> addFolder({
    required String name,
    required int? parentId,
    required String color,
  }) async {
    final folder = Folder.create(
      name: name,
      parentId: parentId,
      color: color,
    );
    await ref.read(folderRepositoryProvider).insert(folder);
    refresh(parentId);
  }

  Future<void> updateFolder(Folder folder) async {
    await ref.read(folderRepositoryProvider).update(folder);
    refresh(folder.parentId);
  }

  Future<void> deleteFolder(int id, int? parentId) async {
    await ref.read(folderRepositoryProvider).delete(id);
    refresh(parentId);
  }

  List<Folder> buildFolderTree(List<Folder> folders) {
    final Map<int?, List<Folder>> folderMap = {};

    // Group folders by parentId
    for (var folder in folders) {
      if (!folderMap.containsKey(folder.parentId)) {
        folderMap[folder.parentId] = [];
      }
      folderMap[folder.parentId]!.add(folder);
    }

    // Return root folders (parentId = null)
    return folderMap[null] ?? [];
  }

  List<Folder> getChildFolders(List<Folder> allFolders, int parentId) {
    return allFolders.where((folder) => folder.parentId == parentId).toList();
  }
}
