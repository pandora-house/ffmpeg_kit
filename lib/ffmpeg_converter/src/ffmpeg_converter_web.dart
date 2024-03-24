//ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
import 'dart:typed_data';

import '../../file_picker/file_picker.dart';
import 'js_bindings.dart'
    as bind;

import 'ffmpeg_converter_i.dart';

class FfmpegConverter implements IFfmpegConverter {
  @override
  Future<FileDto?> convertVideo({
    required String name,
    required String path,
    required Uint8List bytes,
  }) async {
    final promise = bind.convertVideo(bytes, name);
    final data = await promiseToFuture<ByteBuffer?>(promise as Object);
    if (data == null) {
      return null;
    }
    final fileName = name.split('.')..removeLast();
    return FileDto(
      bytes: data.asUint8List(),
      name: '${fileName.join()}.mp4',
    );
  }

  @override
  Future<FileDto?> convertAudio({
    required String name,
    required String path,
    required Uint8List bytes,
  }) async {
    final promise = bind.convertAudio(bytes, name);
    final data = await promiseToFuture<ByteBuffer?>(promise as Object);
    if (data == null) {
      return null;
    }
    final fileName = name.split('.')..removeLast();
    return FileDto(
      bytes: data.asUint8List(),
      name: '${fileName.join()}.mp3',
    );
  }

  @override
  Future<void> removeTemporaryFile(String? fileName) async {}
}
