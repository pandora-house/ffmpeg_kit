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
    _$readFilesId: ($) async {
      final $r = await readFiles($.args[0]);
      return $r.cast<dynamic>();
    },
  });

  static const int _$readFilesId = 1;
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
      : super(
          $FilePickerManagerActivator,
          platformWorkerHook: platformWorkerHook,
        );

  @override
  Future<List<dynamic>> readFiles(dynamic list) =>
      send(_$FilePickerManagerWorkerService._$readFilesId, args: [list])
          .then((_) => _ as List);
}

/// Worker pool for FilePickerManager
class FilePickerManagerWorkerPool extends WorkerPool<FilePickerManagerWorker>
    implements FilePickerManager {
  FilePickerManagerWorkerPool({
    ConcurrencySettings? concurrencySettings,
    PlatformWorkerHook? platformWorkerHook,
  }) : super(
          () => FilePickerManagerWorker(platformWorkerHook: platformWorkerHook),
          concurrencySettings: concurrencySettings,
        );

  @override
  Future<List<dynamic>> readFiles(dynamic list) =>
      execute((w) => w.readFiles(list));
}
