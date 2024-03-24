import 'package:flutter/material.dart';

import 'file_picker_bridge_i.dart';

class FilePickerBridge implements IFilePickerBridge {
  @override
  Stream<FilePickerEvent> addAttachments({
    required BuildContext context,
    dynamic fileType,
  }) async* {
    throw UnimplementedError();
  }
}
