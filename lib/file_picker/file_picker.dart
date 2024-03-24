export 'src/dto/file_dto.dart';
export 'src/file_picker_bridge_i.dart';
export 'src/file_picker_bridge_stub.dart'
    if (dart.library.js) 'src/file_picker_bridge_web.dart'
    if (dart.library.html) 'src/file_picker_bridge_web.dart'
    if (dart.library.io) 'src/file_picker_bridge_io.dart';
