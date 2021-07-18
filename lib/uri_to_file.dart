import 'dart:io';

import 'package:flutter/services.dart';

class UriToFile {
  /// MethodChannel Helper
  static const MethodChannel _methodChannel =
      const MethodChannel('in.lazymanstudios.uritofile/helper');

  /// Error code for PlatformException
  static const String URI_NOT_SUPPORTED = 'URI_NOT_SUPPORTED';

  /// Error code for PlatformException
  static const String IO_EXCEPTION = 'IO_EXCEPTION';

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
