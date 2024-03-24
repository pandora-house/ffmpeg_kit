import 'dart:typed_data';

import '../../file_picker/file_picker.dart';
import 'ffmpeg_converter_i.dart';


class FfmpegConverter implements IFfmpegConverter {
  @override
  Future<FileDto?> convertVideo({
    required String name,
    required String path,
    required Uint8List bytes,
  }) {
    throw UnimplementedError('Unsupported platform');
  }

  @override
  Future<FileDto?> convertAudio({
    required String name,
    required String path,
    required Uint8List bytes,
  }) {
    throw UnimplementedError('Unsupported platform');
  }

  @override
  Future<void> removeTemporaryFile(String? fileName) {
    throw UnimplementedError('Unsupported platform');
  }
}
