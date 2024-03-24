import 'dart:async';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import '../../ffmpeg_converter/ffmpeg_converter.dart';
import 'file_picker_bridge_i.dart';
import 'web/file_picker_html.dart';
import 'web/file_picker_manager.dart' as picker_web;

import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:squadron/squadron.dart';

import 'dto/file_dto.dart';

class FilePickerBridge implements IFilePickerBridge {
  @override
  Stream<FilePickerEvent> addAttachments({
    required BuildContext context,
    dynamic fileType,
  }) async* {
    final pickedFiles =
        await FilePickerHtml.platform.pickFiles(allowMultiple: true);

    final pool = picker_web.FilePickerManagerWorkerPool(
      concurrencySettings: ConcurrencySettings.threeCpuThreads,
    );
    await pool.start();
    final files =
        (await pool.readFiles(pickedFiles)).map(FileDto.fromHashMap).toList();
    pool.stop();

    final (List<FileDto> video, List<FileDto> audio, List<XFile> list) =
        await _splitFiles(files);

    yield FilePickerAddFiles(list);

    for (final file in audio) {
      final data = await FfmpegConverter().convertAudio(
        path: '',
        bytes: file.bytes,
        name: file.name,
      );
      yield FilePickerAddConverted(
        XFile('',
            name: data?.name ?? file.name, bytes: data?.bytes ?? file.bytes),
      );
    }

    for (final file in video) {
      final data = await FfmpegConverter().convertVideo(
        path: '',
        bytes: file.bytes,
        name: file.name,
      );
      yield FilePickerAddConverted(
        XFile(
          '',
          name: data?.name ?? file.name,
          bytes: data?.bytes ?? file.bytes,
        ),
      );
    }
  }

  Future<(List<FileDto> video, List<FileDto> audio, List<XFile> list)>
      _splitFiles(
    List<FileDto> files,
  ) async {
    final list = <XFile>[];
    final video = <FileDto>[];
    final audio = <FileDto>[];

    for (final file in files) {
      if (file.bytes.isEmpty) {
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
            bytes: file.bytes,
          ),
        );
        continue;
      }

      final fileDto = FileDto(
        bytes: file.bytes,
        name: file.name,
        path: file.path,
      );

      if (isAudio) {
        audio.add(fileDto);
      } else if (isVideo) {
        video.add(fileDto);
      }
      list.add(XFile.fromData(Uint8List(0), name: file.name));
    }
    return (video, audio, list);
  }
}
