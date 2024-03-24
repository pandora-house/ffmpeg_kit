import 'dart:typed_data';

import '../../file_picker/src/dto/file_dto.dart';

abstract interface class IFfmpegConverter {
  Future<FileDto?> convertVideo({
    required String name,
    required String path,
    required Uint8List bytes,
  });

  Future<FileDto?> convertAudio({
    required String name,
    required String path,
    required Uint8List bytes,
  });

  Future<void> removeTemporaryFile(String? fileName);
}
