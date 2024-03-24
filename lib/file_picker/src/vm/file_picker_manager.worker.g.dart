// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_picker_manager.dart';

// **************************************************************************
// Generator: WorkerGenerator 2.4.2
// **************************************************************************

/// WorkerService class for FilePickerManager
class _$FilePickerManagerWorkerService extends FilePickerManager
    implements WorkerService {
  _$FilePickerManagerWorkerService() : super();

  @override
  Map<int, CommandHandler> get operations => _operations;

  late final Map<int, CommandHandler> _operations =
      Map.unmodifiable(<int, CommandHandler>{
    _$convertAudioId: ($) => convertAudio($.args[0].cast<XFile>()),
    _$convertVideoId: ($) => convertVideo($.args[0].cast<XFile>()),
    _$selectFilesId: ($) async {
      final $r = await selectFiles(token: $.args[0]);
      return $r.cast<FileDto>();
    },
    _$splitFilesId: ($) => splitFiles($.args[0].cast<FileDto>()),
  });

  static const int _$convertAudioId = 1;
  static const int _$convertVideoId = 2;
  static const int _$selectFilesId = 3;
  static const int _$splitFilesId = 4;
}

/// Service initializer for FilePickerManager
WorkerService $FilePickerManagerInitializer(WorkerRequest startRequest) =>
    _$FilePickerManagerWorkerService();

/// Operations map for FilePickerManager
@Deprecated(
    'squadron_builder now supports "plain old Dart objects" as services. '
    'Services do not need to derive from WorkerService nor do they need to mix in '
    'with \$FilePickerManagerOperations anymore.')
mixin $FilePickerManagerOperations on WorkerService {
  @override
  // not needed anymore, generated for compatibility with previous versions of squadron_builder
  Map<int, CommandHandler> get operations => WorkerService.noOperations;
}

/// Worker for FilePickerManager
class FilePickerManagerWorker extends Worker implements FilePickerManager {
  FilePickerManagerWorker({PlatformWorkerHook? platformWorkerHook})
      : super($FilePickerManagerActivator,
            platformWorkerHook: platformWorkerHook);

  @override
  Stream<XFile> convertAudio(List<XFile> files) =>
      stream(_$FilePickerManagerWorkerService._$convertAudioId,
          args: [files.cast<XFile>()]);

  @override
  Stream<XFile> convertVideo(List<XFile> files) =>
      stream(_$FilePickerManagerWorkerService._$convertVideoId,
          args: [files.cast<XFile>()]);

  @override
  Future<List<FileDto>> selectFiles({dynamic token}) =>
      send(_$FilePickerManagerWorkerService._$selectFilesId, args: [token])
          .then((_) => _.cast<FileDto>());

  @override
  Future<(List<XFile>, List<XFile>, List<XFile>)> splitFiles(
          List<FileDto> files) =>
      send(_$FilePickerManagerWorkerService._$splitFilesId,
          args: [files.cast<FileDto>()]);
}

/// Worker pool for FilePickerManager
class FilePickerManagerWorkerPool extends WorkerPool<FilePickerManagerWorker>
    implements FilePickerManager {
  FilePickerManagerWorkerPool(
      {ConcurrencySettings? concurrencySettings,
      PlatformWorkerHook? platformWorkerHook})
      : super(
            () =>
                FilePickerManagerWorker(platformWorkerHook: platformWorkerHook),
            concurrencySettings: concurrencySettings);

  @override
  Stream<XFile> convertAudio(List<XFile> files) =>
      stream((w) => w.convertAudio(files));

  @override
  Stream<XFile> convertVideo(List<XFile> files) =>
      stream((w) => w.convertVideo(files));

  @override
  Future<List<FileDto>> selectFiles({dynamic token}) =>
      execute((w) => w.selectFiles(token: token));

  @override
  Future<(List<XFile>, List<XFile>, List<XFile>)> splitFiles(
          List<FileDto> files) =>
      execute((w) => w.splitFiles(files));
}
