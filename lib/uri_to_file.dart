import 'dart:io';

import 'package:flutter/services.dart';
import 'model/custom_exception/uri_io_exception.dart';

/// Method Channel Helper
const MethodChannel _methodChannel =
    const MethodChannel('in.lazymanstudios.uritofile/helper');

// Check testing mode
bool get isTesting => Platform.environment.containsKey('FLUTTER_TEST');

/// Error code for PlatformException
const String _URI_NOT_SUPPORTED = 'URI_NOT_SUPPORTED';

/// Error code for PlatformException
const String _IO_EXCEPTION = 'IO_EXCEPTION';

/// Check [Uri] is supported or not
///
/// Supported [Uri] scheme same as supported by File.fromUri(uri) with content [Uri] (Android Only)
///
/// returns
/// - true  if [Uri] supported
/// - false if [Uri] not supported
///
/// [bool] isTesting used for testing purpose
bool isUriSupported(Uri uri) {
  if ((Platform.isAndroid || isTesting) && uri.isScheme('content')) {
    return true;
  }

  try {
    File.fromUri(uri);
    return true;
  } catch (e) {
    return false;
  }
}

/// Create a [File] object from a [Uri].
///
/// Supported [Uri] scheme same as supported by File.fromUri(uri) with content [Uri] (Android Only)
///
/// If [Uri] cannot reference a file this throws [UnsupportedError] or [IOException]
///
/// [bool] isTesting used for testing purpose
Future<File> toFile(Uri uri) async {
  if ((Platform.isAndroid || isTesting) && uri.isScheme('content')) {
    try {
      String filepath = await _methodChannel
          .invokeMethod("fromUri", {"uriString": uri.toString()});
      return File(filepath);
    } on PlatformException catch (e) {
      switch (e.code) {
        case _URI_NOT_SUPPORTED:
          {
            throw UnsupportedError(
                'Cannot extract a file path from a ${uri.scheme} URI');
          }
        case _IO_EXCEPTION:
          {
            throw UriIOException(e.message);
          }
        default:
          {
            rethrow;
          }
      }
    } on Exception {
      rethrow;
    }
  }

  return File.fromUri(uri);
}
