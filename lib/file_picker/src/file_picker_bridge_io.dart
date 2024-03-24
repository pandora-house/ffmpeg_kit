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
        await pool.selectFiles(token: RootIsolateToken.instance);

    final (List<XFile> video, List<XFile> audio, List<XFile> list) =
        await pool.splitFiles(files);

    yield FilePickerAddFiles(list);

    yield* MergeStream([
      pool.convertAudio(audio),
      pool.convertVideo(video),
    ]).map(FilePickerAddConverted.new).doOnDone(pool.stop);
  }
}
