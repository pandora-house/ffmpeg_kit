@JS()
library script.js;

import 'dart:typed_data';

import 'package:js/js.dart';

@JS('ffmpeg_js.convertVideo')
external dynamic convertVideo(Uint8List rawFile, String inputFileName);

@JS('ffmpeg_js.convertAudio')
external dynamic convertAudio(Uint8List rawFile, String inputFileName);
