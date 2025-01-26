import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';
part 'folder.g.dart';

@freezed
class Folder with _$Folder {
  const factory Folder({
    required int id,
    required String name,
    int? parentId,
    String? color,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Folder;

  factory Folder.create({
    required String name,
    int? parentId,
    String? color,
  }) =>
      Folder(
        id: -1,
        name: name,
        parentId: parentId,
        color: color,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  static Map<String, dynamic> toDB(Folder folder) => {
        'id': folder.id,
        'name': folder.name,
        'parent_id': folder.parentId,
        'color': folder.color,
        'created_at': folder.createdAt.toIso8601String(),
        'updated_at': folder.updatedAt.toIso8601String(),
        'deleted_at': folder.deletedAt?.toIso8601String(),
      };

  static Folder fromDB(Map<String, dynamic> map) => Folder(
        id: map['id'] as int,
        name: map['name'] as String,
        parentId: map['parent_id'] as int?,
        color: map['color'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        deletedAt: map['deleted_at'] != null
            ? DateTime.parse(map['deleted_at'] as String)
            : null,
      );
}
