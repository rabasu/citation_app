import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/note.dart';
import '../data/models/source.dart';
import 'note_repository_provider.dart';

part 'note_list_provider.g.dart';

@riverpod
class NoteList extends _$NoteList {
  @override
  Future<List<Note>> build([int? folderId]) async {
    final repository = ref.watch(noteRepositoryProvider);
    return repository.getByFolderId(folderId);
  }

  Future<void> refresh(int? folderId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.read(noteRepositoryProvider).getByFolderId(folderId));
  }

  Future<void> deleteNote(int id) async {
    await ref.read(noteRepositoryProvider).delete(id);
    refresh(null);
  }

  Future<void> addNote(Note note) async {
    await ref.read(noteRepositoryProvider).insert(note);
    refresh(null);
  }

  Future<void> updateNote(Note note) async {
    await ref.read(noteRepositoryProvider).update(note);
    refresh(null);
  }

  Future<List<Note>> getNotesBySourceId(int sourceId) async {
    return ref.read(noteRepositoryProvider).getBySourceId(sourceId);
  }

  Future<List<Note>> getNotesByFolderId(int folderId) async {
    return ref.read(noteRepositoryProvider).getByFolderId(folderId);
  }

  Future<List<Note>> searchNotes(String query,
      {Source? source, int? folderId}) async {
    final notes =
        await ref.read(noteRepositoryProvider).getByFolderId(folderId);

    return notes.where((note) {
      final matchesQuery = query.isEmpty ||
          (note.title?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          note.content.toLowerCase().contains(query.toLowerCase());

      final matchesSource = source == null || note.sourceId == source.id;
      final matchesFolder = folderId == null || note.folderId == folderId;

      return matchesQuery && matchesSource && matchesFolder;
    }).toList();
  }

  Future<void> moveNoteToFolder(Note note, int? folderId) async {
    final updatedNote = note.copyWith(folderId: folderId);
    await updateNote(updatedNote);
  }
}
