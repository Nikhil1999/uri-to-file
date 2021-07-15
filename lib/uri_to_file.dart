import 'dart:io';

import 'package:flutter/services.dart';

class UriToFile {
  static const MethodChannel _methodChannel =
      const MethodChannel('in.lazymanstudios.uritofile/helper');

  /// To convert a uri to file
  ///
  /// Supported uri schema
  /// - content
  static Future<File> toFile(String uriString) async {
    String filepath =
        await _methodChannel.invokeMethod("fromUri", {"uriString": uriString});
    return File(filepath);
  }
}
