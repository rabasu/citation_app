import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder.freezed.dart';
part 'folder.g.dart';

@freezed
class Folder with _$Folder {
  const factory Folder({
    required String id,
    required String name,
    String? parentId,
    String? color,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Folder;

  factory Folder.fromJson(Map<String, dynamic> json) => _$FolderFromJson(json);

  static Map<String, dynamic> toDB(Folder folder) => {
        'id': folder.id,
        'name': folder.name,
        'parent_id': folder.parentId,
        'color': folder.color,
        'created_at': folder.createdAt.toIso8601String(),
        'updated_at': folder.updatedAt.toIso8601String(),
      };

  static Folder fromDB(Map<String, dynamic> map) => Folder(
        id: map['id'] as String,
        name: map['name'] as String,
        parentId: map['parent_id'] as String?,
        color: map['color'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );
}
