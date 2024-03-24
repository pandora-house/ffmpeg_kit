import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:squadron/squadron.dart';

import '../../../ffmpeg_converter/ffmpeg_converter.dart';
import '../dto/file_dto.dart';
import 'file_picker_manager_activator.dart';

/// import 'package:squadron/squadron_annotations.dart';

part 'file_picker_manager_worker.dart';

/// @SquadronService(web: false)
class FilePickerManager {
  const FilePickerManager();

  /// @SquadronMethod()
  Future<(List<XFile> video, List<XFile> audio, List<XFile> list)> splitFiles(
    List<FileDto> files,
  ) async {
    final list = <XFile>[];
    final video = <XFile>[];
    final audio = <XFile>[];

    for (final file in files) {
      if (file.path.isEmpty) {
        continue;
      }

      final mimeType = lookupMimeType(file.name);
      final isVideo = mimeType?.contains('video') ?? false;
      final isAudio = mimeType?.contains('audio') ?? false;

      // Mitryaev исключаем конверсию мп3
      final excludeMp3 = isAudio && file.name.contains('.mp3');

      if (!isVideo && !isAudio || excludeMp3) {
        list.add(
          XFile(
            file.path,
            name: file.name,
          ),
        );
        continue;
      }

      final xFileDto = XFile.fromData(
        file.bytes,
        name: file.name,
        path: file.path,
      );

      if (isAudio) {
        audio.add(xFileDto);
      } else if (isVideo) {
        video.add(xFileDto);
      }
      list.add(XFile.fromData(Uint8List(0), name: file.name));
    }
    return (video, audio, list);
  }

  /// @SquadronMethod()
  Stream<XFile> convertVideo(List<XFile> files) async* {
    for (final file in files) {
      final data = await FfmpegConverter().convertVideo(
        path: file.path,
        name: file.name,
        bytes: Uint8List(0),
      );

      yield data?.path.isEmpty ?? true
          ? file
          : XFile(
              data!.path,
              name: data.name,
            );
    }
  }

  /// @SquadronMethod()
  Stream<XFile> convertAudio(List<XFile> files) async* {
    for (final file in files) {
      final data = await FfmpegConverter().convertAudio(
        path: file.path,
        name: file.name,
        bytes: Uint8List(0),
      );

      yield data?.path.isEmpty ?? true
          ? file
          : XFile(
              data!.path,
              name: data.name,
            );
    }
  }

  /// @SquadronMethod()
  Future<List<FileDto>> selectFiles({
    required FileType fileType,
    required List<String>? allowedExtensions,
    dynamic token,
  }) async {
    if (token != null) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(
        token as RootIsolateToken,
      );
    }

    final selected = <FileDto>[];

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: fileType,
      allowedExtensions: allowedExtensions,
    );

    if (result == null) {
      return <FileDto>[];
    }

    for (final file in result.files) {
      selected.add(
        FileDto(
          path: file.path ?? '',
          name: file.name,
          bytes: file.bytes ?? Uint8List(0),
        ),
      );
    }

    return selected;
  }
}
