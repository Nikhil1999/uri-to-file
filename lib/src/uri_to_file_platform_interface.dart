import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'uri_to_file_method_channel.dart';

/// UriToFilePlatformInterface
abstract class UriToFilePlatform extends PlatformInterface {
  /// Constructs a UriToFilePlatform.
  UriToFilePlatform() : super(token: _token);

  static final Object _token = Object();

  static UriToFilePlatform _instance = MethodChannelUriToFile();

  /// The default instance of [UriToFilePlatform] to use.
  ///
  /// Defaults to [MethodChannelUriToFile].
  static UriToFilePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UriToFilePlatform] when
  /// they register themselves.
  static set instance(UriToFilePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Check Uri is supported or not
  bool isUriSupported(String uriString) {
    throw UnimplementedError('isUriSupported() has not been implemented.');
  }

  /// Convert Uri to file
  Future<File> toFile(String uriString) {
    throw UnimplementedError('toFile() has not been implemented.');
  }

  /// Clears temporary files
  Future<void> clearTemporaryFiles() {
    throw UnimplementedError('clearTemporaryFiles() has not been implemented.');
  }
}
