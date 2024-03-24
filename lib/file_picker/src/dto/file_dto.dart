import 'dart:collection';
import 'dart:typed_data';

class FileDto {
  const FileDto({
    required this.bytes,
    required this.name,
    this.path = '',
  });

  factory FileDto.fromHashMap(dynamic data) {
    final json = data as LinkedHashMap<dynamic, dynamic>;
    return FileDto(
      path: json['path'] as String,
      bytes: json['bytes'] as Uint8List,
      name: json['name'] as String,
    );
  }

  final String path;
  final Uint8List bytes;
  final String name;

  Map<String, dynamic> toJson() => {
        'path': path,
        'bytes': bytes,
        'name': name,
      };
}
