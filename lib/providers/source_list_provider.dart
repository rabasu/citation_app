import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/source.dart';
import 'source_repository_provider.dart';

part 'source_list_provider.g.dart';

@riverpod
class SourceList extends _$SourceList {
  @override
  Future<List<Source>> build() async {
    final repository = ref.watch(sourceRepositoryProvider);
    return repository.getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(sourceRepositoryProvider).getAll());
  }

  Future<Source> addSource({
    required String title,
    String? url,
    String? description,
  }) async {
    final source = Source.create(
      title: title,
      url: url,
      description: description,
    );
    final result = await ref.read(sourceRepositoryProvider).insert(source);
    refresh();
    return result;
  }

  Future<void> deleteSource(int id) async {
    await ref.read(sourceRepositoryProvider).delete(id);
    refresh();
  }
}
