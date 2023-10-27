import 'dart:io';

import 'package:flutter/services.dart';

import 'src/uri_to_file_platform_interface.dart';

export 'src/uri_to_file_ios.dart';
export 'src/uri_to_file_method_channel.dart';
export 'src/uri_to_file_platform_interface.dart';

/// Check uri is supported or not
///
/// Don't pass uri parameter using [Uri] object via uri.toString().
/// Because uri.toString() changes the string to lowercase which causes this package to misbehave
///
/// If you are using uni_links package for deep linking purpose.
/// Pass the uri string using getInitialLink() or linkStream
///
/// Supported uri scheme same as supported by File.fromUri(uri) with content uri (Android Only)
///
/// returns
/// - true  if uri supported
/// - false if uri not supported
bool isUriSupported(String uriString) {
  return UriToFilePlatform.instance.isUriSupported(uriString);
}

/// Create a [File] object from a uri.
///
/// Don't pass uri parameter using [Uri] object via uri.toString().
/// Because uri.toString() changes the string to lowercase which causes this package to misbehave
///
/// If you are using uni_links package for deep linking purpose.
/// Pass the uri string using getInitialLink() or linkStream
///
/// Supported uri scheme same as supported by File.fromUri(uri) with content uri (Android Only)
///
/// If uri cannot reference a file this throws [PlatformException] or [IOException]
Future<File> toFile(String uriString) {
  return UriToFilePlatform.instance.toFile(uriString);
}

/// Clears temporary files created by this plugin
Future<void> clearTemporaryFiles() {
  return UriToFilePlatform.instance.clearTemporaryFiles();
}
