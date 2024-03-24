import 'dart:async';
import 'dart:html';

class FilePickerHtml {
  FilePickerHtml._() {
    _target = _ensureInitialized(_kFilePickerInputsDomId);
  }

  late Element _target;
  final String _kFilePickerInputsDomId = '__file_picker_web-file-input';

  static final FilePickerHtml platform = FilePickerHtml._();

  /// Initializes a DOM container where we can host input elements.
  Element _ensureInitialized(String id) {
    var target = querySelector('#$id');
    if (target == null) {
      final targetElement = Element.tag('flt-file-picker-inputs')..id = id;

      querySelector('body')!.children.add(targetElement);
      target = targetElement;
    }
    return target;
  }

  Future<List<File>?> pickFiles({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    final filesCompleter = Completer<List<File>?>();

    final uploadInput = FileUploadInputElement() as InputElement;
    uploadInput.draggable = true;
    uploadInput.multiple = allowMultiple;
    uploadInput.accept = '';
    uploadInput.style.display = 'none';

    var changeEventTriggered = false;

    void changeEventListener(e) {
      if (changeEventTriggered) {
        return;
      }
      changeEventTriggered = true;

      final files = uploadInput.files!;

      filesCompleter.complete(files);
    }

    void cancelledEventListener(_) {
      window.removeEventListener('focus', cancelledEventListener);

      // This listener is called before the input changed event,
      // and the `uploadInput.files` value is still null
      // Wait for results from js to dart
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (!changeEventTriggered) {
          changeEventTriggered = true;
          filesCompleter.complete(null);
        }
      });
    }

    uploadInput.onChange.listen(changeEventListener);
    uploadInput.addEventListener('change', changeEventListener);

    // Listen focus event for cancelled
    window.addEventListener('focus', cancelledEventListener);

    //Add input element to the page body
    _target.children.clear();
    _target.children.add(uploadInput);
    uploadInput.click();

    final files = await filesCompleter.future;

    return files;
  }
}
