import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

abstract class FilePickerEvent {
  const FilePickerEvent();
}

class FilePickerAddFiles implements FilePickerEvent {
  const FilePickerAddFiles(this.files);

  final List<XFile> files;
}

class FilePickerAddConverted implements FilePickerEvent {
  const FilePickerAddConverted(this.file);
  final XFile file;
}

abstract interface class IFilePickerBridge {
  Stream<FilePickerEvent> addAttachments({
    required BuildContext context,
    dynamic fileType,
  });
}
