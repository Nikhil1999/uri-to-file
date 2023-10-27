import 'dart:io';

import 'package:uri_to_file/src/uri_to_file_platform_interface.dart';

/// The iOS implementation of [UriToFilePlatform].
class UriToFilePluginIOS extends UriToFilePlatform {
  /// Register this dart class as the platform implementation for iOS
  static void registerWith() {
    UriToFilePlatform.instance = UriToFilePluginIOS();
  }

  @override
  bool isUriSupported(String uriString) {
    try {
      Uri uri = Uri.parse(uriString);
      File.fromUri(uri);

      return true;
    } catch (_) {}
    return false;
  }

  @override
  Future<File> toFile(String uriString) async {
    Uri uri = Uri.parse(uriString);
    return File.fromUri(uri);
  }

  @override
  Future<void> clearTemporaryFiles() async {}
}
