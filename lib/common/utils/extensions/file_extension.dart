import 'dart:async';
import 'dart:html' as html;
import 'dart:io';

import 'package:flutter/foundation.dart';

extension FileModifier on html.File {
  Future<Uint8List> asBytesFromHtmlFile() async {
    final bytesFile = Completer<List<int>>();
    final reader = html.FileReader();
    reader.onLoad.listen(
            (event) => bytesFile.complete(reader.result as FutureOr<List<int>>?));
    reader.readAsArrayBuffer(this);
    return Uint8List.fromList(await bytesFile.future);
  }
}