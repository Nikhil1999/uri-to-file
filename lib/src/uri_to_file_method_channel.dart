import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'uri_to_file_platform_interface.dart';

/// An implementation of [UriToFilePlatform] that uses method channels.
class MethodChannelUriToFile extends UriToFilePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('in.lazymanstudios.uritofile/helper');

  @override
  bool isUriSupported(String uriString) {
    try {
      Uri uri = Uri.parse(uriString);
      if (uri.isScheme('content')) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  @override
  Future<File> toFile(String uriString) async {
    String filepath =
        await methodChannel.invokeMethod("fromUri", {"uriString": uriString});
    return File(filepath);
  }

  @override
  Future<void> clearTemporaryFiles() async {
    await methodChannel.invokeMethod("clearTemporaryFiles");
  }
}
