import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required int id,
    String? title,
    required String content,
    int? sourceId,
    String? page,
    int? folderId,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Note;

  factory Note.create({
    String? title,
    required String content,
    int? sourceId,
    String? page,
    int? folderId,
  }) =>
      Note(
        id: -1,
        title: title,
        content: content,
        sourceId: sourceId,
        page: page,
        folderId: folderId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

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
        'deleted_at': note.deletedAt?.toIso8601String(),
      };

  static Note fromDB(Map<String, dynamic> map) => Note(
        id: map['id'] as int,
        title: map['title'] as String?,
        content: map['content'] as String,
        sourceId: map['source_id'] as int?,
        page: map['page'] as String?,
        folderId: map['folder_id'] as int?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        deletedAt: map['deleted_at'] != null
            ? DateTime.parse(map['deleted_at'] as String)
            : null,
      );
}
