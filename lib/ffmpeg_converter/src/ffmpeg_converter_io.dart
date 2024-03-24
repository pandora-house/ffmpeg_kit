import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../file_picker/file_picker.dart';
import 'ffmpeg_converter_i.dart';

class FfmpegConverter implements IFfmpegConverter {
  Future<bool> _runProcess({
    required String executable,
    required List<String> commandArgs,
  }) async {
    final process = await Process.run(
      executable,
      commandArgs,
    );

    return process.exitCode == ReturnCode.success;
  }

  Future<FileDto?> _baseConverter({
    required String outputPath,
    required String outputFileName,
    required List<String> commandArgs,
  }) async {
    if (Platform.isWindows || Platform.isLinux) {
      final executable = Platform.isWindows
          //TODO(biosice): вынести путь до ffmpeg.exe в параметр workingDirectory
          ? join(
              dirname(Platform.resolvedExecutable),
              r'data\flutter_assets\assets\ffmpeg\ffmpeg.exe',
            )
          : 'ffmpeg';

      final success = await _runProcess(
        executable: executable,
        commandArgs: commandArgs,
      );
      return success
          ? FileDto(
              path: outputPath,
              name: outputFileName,
              bytes: Uint8List(0),
            )
          : null;
    }

    final session = await FFmpegKit.executeWithArguments(commandArgs);

    final sessionCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(sessionCode)) {
      await session.cancel();

      return FileDto(
        path: outputPath,
        name: outputFileName,
        bytes: Uint8List(0),
      );
    } else {
      // Mitryaev оставить для дебага
      // final logs = await session.getLogs();
      // print('===============');
      // for (final e in logs) {
      //   print(e.getMessage());
      // }
      await session.cancel();
      return null;
    }
  }

  @override
  Future<FileDto?> convertVideo({
    required String name,
    required String path,
    required Uint8List bytes,
  }) async {
    final inputPath = path;
    final extension = path.split('.').last;

    var outputFileName = name.replaceFirst('.$extension', '.mp4');

    final tempDir = await getTemporaryDirectory();
    var tmpOutputPath = Platform.isWindows
        ? '${tempDir.path}\\$outputFileName'
        : '${tempDir.path}/$outputFileName';

    if (inputPath == tmpOutputPath) {
      final newName =
          '${name.replaceFirst('.$extension', '')}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      tmpOutputPath = tmpOutputPath.replaceFirst(outputFileName, newName);
      outputFileName = newName;
    }

    final outputPath = tmpOutputPath;

    // TODO(Mitryaev): handle error process.exitCode != 0
    // TODO(Mitryaev): возможно есть вариант конвертировать сразу несколько файлов
    /// '-y' автоматически переписывать существующий файл
    /// https://trac.ffmpeg.org/wiki/Encode/H.264
    /// -preset ultrafast,superfast,veryfast,faster,fast,medium,low,slower,veryslow,placebo
    /// -crf 0-51
    /// -profile:v high сделал по примеру онлайн конвертера
    /// -map 0 -movflags faststart меняет метаданные mediaDataSize, mediaDataOffset, иначе ios vlc_player не воспроизводит видео
    final commandArgs = [
      '-y',
      '-i',
      inputPath,
      if (!Platform.isLinux) '-profile:v',// возникли проблемы при обработке видео записанного с вебкамеры
      if (!Platform.isLinux) 'high',// по-хорошему нужно сразу конвертировать видео при записи с камеры
      '-c:v',
      'libx264',
      '-preset',
      'ultrafast',
      '-crf',
      '36',
      '-map',
      '0',
      '-movflags',
      'faststart',
      outputPath,
    ];

    return _baseConverter(
      outputPath: outputPath,
      outputFileName: outputFileName,
      commandArgs: commandArgs,
    );
  }

  // TODO(Mitryaev): handle error process.exitCode != 0
  // TODO(Mitryaev): почему-то с воспроизведением сконвертированного файла м4а, возникли проблемы, делаю перевод в мп3. На винде реализацию проверить не смог.
  @override
  Future<FileDto?> convertAudio({
    required String name,
    required String path,
    required Uint8List bytes,
  }) async {
    final inputPath = path;
    final extension = path.split('.').last;

    final outputFileName = name.replaceFirst('.$extension', '.mp3');

    final tempDir = await getTemporaryDirectory();
    final tmpOutputPath = Platform.isWindows
        ? '${tempDir.path}\\$outputFileName'
        : '${tempDir.path}/$outputFileName';

    final outputPath = tmpOutputPath;

    /// https://trac.ffmpeg.org/wiki/Encode/AAC
    var commandArgs = [
      '-y',
      '-i',
      inputPath,
      '-c:a',
      'libmp3lame',
      outputPath,
    ];

    if (Platform.isWindows) {
      commandArgs = [
        '-y',
        '-i',
        inputPath,
        outputPath,
      ];
    }

    return _baseConverter(
      outputPath: outputPath,
      outputFileName: outputFileName,
      commandArgs: commandArgs,
    );
  }

  /// В стейте одинаковые файла ссылаются на один путь!
  @override
  Future<void> removeTemporaryFile(String? fileName) async {
    if (fileName == null) {
      return;
    }
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    try {
      await file.delete();
    } catch (_) {
      // TODO(Mitryaev): вероятно даже и не нужно обрабатывать ошибку
    }
  }
}
