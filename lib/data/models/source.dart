import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';
part 'source.g.dart';

@freezed
class Source with _$Source {
  const factory Source({
    required int id,
    required String title,
    String? url,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Source;

  factory Source.create({
    required String title,
    String? url,
    String? description,
  }) =>
      Source(
        id: -1,
        title: title,
        url: url,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  static Map<String, dynamic> toDB(Source source) => {
        'id': source.id,
        'title': source.title,
        'url': source.url,
        'description': source.description,
        'created_at': source.createdAt.toIso8601String(),
        'updated_at': source.updatedAt.toIso8601String(),
        'deleted_at': source.deletedAt?.toIso8601String(),
      };

  static Source fromDB(Map<String, dynamic> map) => Source(
        id: map['id'] as int,
        title: map['title'] as String,
        url: map['url'] as String?,
        description: map['description'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
        deletedAt: map['deleted_at'] != null
            ? DateTime.parse(map['deleted_at'] as String)
            : null,
      );
}
