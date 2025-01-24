import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    String? sourceId,
    String? page,
    String? folderId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  static Map<String, dynamic> toDB(Note note) => {
        'id': note.id,
        'title': note.title,
        'content': note.content,
        'source_id': note.sourceId,
        'page': note.page,
        'folder_id': note.folderId,
        'created_at': note.createdAt.toIso8601String(),
        'updated_at': note.updatedAt.toIso8601String(),
      };

  static Note fromDB(Map<String, dynamic> map) => Note(
        id: map['id'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
        sourceId: map['source_id'] as String?,
        page: map['page'] as String?,
        folderId: map['folder_id'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );
}
