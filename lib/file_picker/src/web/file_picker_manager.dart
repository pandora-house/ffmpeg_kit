import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:squadron/squadron.dart';

import '../dto/file_dto.dart';
import 'file_picker_manager_activator.dart';
/// import 'package:squadron/squadron_annotations.dart';

part 'file_picker_manager_worker.dart';

/// @SquadronService(vm: false, baseUrl: '/workers')
class FilePickerManager {
  const FilePickerManager();

  /// @SquadronMethod()
  Future<List<dynamic>> readFiles(dynamic list) async {
    final files = list as List<dynamic>?;

    if (files?.isEmpty ?? true) {
      return <Map<String, dynamic>>[];
    }

    final filesCompleter = Completer<List<Map<String, dynamic>>>();
    final data = <Map<String, dynamic>>[];

    for (final e in files ?? []) {
      final file = e as File;
      final reader = FileReader();
      reader.onLoadEnd.listen((e) {
        data.add(
          FileDto(
            name: file.name,
            bytes: reader.result as Uint8List? ?? Uint8List(0),
          ).toJson(),
        );
        if (data.length >= files!.length) {
          filesCompleter.complete(data);
        }
      });
      reader.readAsArrayBuffer(file);
    }
    return filesCompleter.future;
  }
}
