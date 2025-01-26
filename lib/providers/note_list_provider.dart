import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/note.dart';
import '../data/models/source.dart';
import 'note_repository_provider.dart';

part 'note_list_provider.g.dart';

@riverpod
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build() async {
    final repository = ref.watch(noteRepositoryProvider);
    return repository.getAll();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => ref.read(noteRepositoryProvider).getAll());
  }

  Future<void> deleteNote(int id) async {
    await ref.read(noteRepositoryProvider).delete(id);
    refresh();
  }

  Future<void> addNote(Note note) async {
    await ref.read(noteRepositoryProvider).insert(note);
    refresh();
  }

  Future<void> updateNote(Note note) async {
    await ref.read(noteRepositoryProvider).update(note);
    refresh();
  }

  Future<List<Note>> getNotesBySourceId(int sourceId) async {
    return ref.read(noteRepositoryProvider).getBySourceId(sourceId);
  }

  Future<List<Note>> searchNotes(String query, {Source? source}) async {
    final notes = await ref.read(noteRepositoryProvider).getAll();

    return notes.where((note) {
      final matchesQuery = query.isEmpty ||
          (note.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          note.content.toLowerCase().contains(query.toLowerCase());

      final matchesSource = source == null || note.sourceId == source.id;

      return matchesQuery && matchesSource;
    }).toList();
  }
}
