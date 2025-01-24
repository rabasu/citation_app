import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';
part 'source.g.dart';

@freezed
class Source with _$Source {
  const factory Source({
    required String id,
    required String title,
    String? url,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Source;

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  static Map<String, dynamic> toDB(Source source) => {
        'id': source.id,
        'title': source.title,
        'url': source.url,
        'description': source.description,
        'created_at': source.createdAt.toIso8601String(),
        'updated_at': source.updatedAt.toIso8601String(),
      };

  static Source fromDB(Map<String, dynamic> map) => Source(
        id: map['id'] as String,
        title: map['title'] as String,
        url: map['url'] as String?,
        description: map['description'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );
}
