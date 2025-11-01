// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response.g.dart';

@JsonSerializable()
class FileUploadResponse {
  final String url;

  FileUploadResponse(this.url);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FileUploadResponse && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);
}
