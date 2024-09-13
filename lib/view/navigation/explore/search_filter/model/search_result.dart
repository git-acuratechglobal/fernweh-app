import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable(createToJson: false)
class SearchResult {
  SearchResult({
    required this.description,
    required this.placeId,
  });

  final String? description;

  @JsonKey(name: 'place_id')
  final String? placeId;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);

}
