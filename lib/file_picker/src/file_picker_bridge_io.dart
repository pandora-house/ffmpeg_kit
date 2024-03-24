import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'file_picker_bridge_i.dart';
import 'vm/file_picker_manager.dart' as picker_vm;
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:squadron/squadron.dart';

import 'dto/file_dto.dart';

class FilePickerBridge implements IFilePickerBridge {
  @override
  Stream<FilePickerEvent> addAttachments({
    required BuildContext context,
    dynamic fileType,
  }) async* {
    final pool = picker_vm.FilePickerManagerWorkerPool(
      concurrencySettings: ConcurrencySettings.threeCpuThreads,
    );
    await pool.start();

    final List<FileDto> files =
        await pool.selectFiles(
      fileType: fileType,
      token: RootIsolateToken.instance,
      allowedExtensions: allowedExtensions,
    );

    final (List<XFile> video, List<XFile> audio, List<XFile> list) =
        await pool.splitFiles(files);

    yield FilePickerAddFiles(list);

    yield* MergeStream([
      pool.convertAudio(audio),
      pool.convertVideo(video),
    ]).map(FilePickerAddConverted.new).doOnDone(pool.stop);
  }
}

const allowedExtensions = [
  'jpeg',
  'gif',
  'jpg',
  'png',
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'txt',
  'zip',
  'rar',
  'fb2',
  'epub',
  'mobi',
  'mp4',
  'm4a',
  'mp3',
  'avi',
  'mov',
  'mkv',
  '3gp',
  'mpeg',
  'mpg',
  'swf',
  'asf',
  'mp2',
  'wmv',
  'mts',
  'flv',
  'm4v',
  'ogv',
  'ogm',
  'ogg',
  'oga',
  'webm',
  'wav',
  'bmp',
  'webp',
  '7z',
  'gzip',
  'djvu',
  'psd',
];
