import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter ffmpeg',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _filesLoading = <XFile>[];
  final _filesConverted = <XFile>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._filesLoading.map((e) => _FileItem(xFile: e)),
            ..._filesConverted.map((e) => Text(e.name)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                final pickerData = FilePickerBridge().addAttachments(
                  context: context,
                  fileType: FileType.any,
                );

                await for (final data in pickerData) {
                  if (data is FilePickerAddFiles) {
                    setState(() {
                      _filesLoading = data.files;
                    });
                  } else if (data is FilePickerAddConverted) {
                    setState(() {
                      _filesConverted.add(data.file);
                      _filesLoading
                          .removeWhere((e) => e.name == data.file.name);
                    });
                  }
                }
              },
              child: const Text('pick files'),
            )
          ],
        ),
      ),
    );
  }
}

class _FileItem extends StatelessWidget {
  const _FileItem({
    required this.xFile,
  });

  final XFile xFile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox.square(
            dimension: 24, child: CircularProgressIndicator()),
        const SizedBox(width: 12),
        Text(xFile.name),
      ],
    );
  }
}
