import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uri_to_file/uri_to_file.dart';

/// To perform unit testing
///
/// Run:
/// flutter test test\uri_to_file_test.dart
void main() {
  /// Method Channel Helper
  const MethodChannel channel =
      MethodChannel('in.lazymanstudios.uritofile/helper');

  TestWidgetsFlutterBinding.ensureInitialized();

  /// Base sample directory path
  String samplePath =
      'test${Platform.pathSeparator}sample${Platform.pathSeparator}';

  setUp(() {
    /// To create sample directory
    Directory sampleDir = Directory(samplePath);
    if (!sampleDir.existsSync()) {
      sampleDir.createSync();
    }

    /// To setup mock method call handler
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'fromUri':
          {
            File file = File(samplePath + 'content_uri_sample.txt');
            file.createSync();
            await file.writeAsString('Testing uri_to_file package...');
            return file.path;
          }
      }
    });
  });

  tearDown(() {
    /// To delete sample directory if exist
    Directory sampleDir = Directory(samplePath);
    if (sampleDir.existsSync()) {
      sampleDir.deleteSync();
    }

    /// To clean up mock method call handler
    channel.setMockMethodCallHandler(null);
  });

  group('uri_to_file:', () {
    test('Test File URI', () async {
      /// To create a sample file
      print('Create sample file');
      File sampleFile = File(samplePath + 'file_uri_sample.txt');
      sampleFile.createSync();
      await sampleFile.writeAsString('Testing uri_to_file package...');

      /// To create uri from sample file
      print('Create URI from sample file');
      Uri uri = Uri.file(sampleFile.path);

      /// To check uri is supported
      print('Check uri is supported');
      expect(isUriSupported(uri.toString()), true);

      /// To convert uri to file
      print('Convert uri to file');
      File convertedFile = await toFile(uri.toString());

      /// To check file is created
      print('Check file is created');
      expect(convertedFile.existsSync(), true);

      /// To delete the converted file if exist
      if (convertedFile.existsSync()) {
        print('Delete converted file');
        convertedFile.deleteSync();
      }

      print('');
    });

    /*
    test('Test Content URI', () async {
      /// To create a sample uri
      print('Create sample content uri');
      Uri uri = Uri.parse('content://content_uri_sample.txt');

      /// To check uri is supported
      print('Check sample uri is supported');
      expect(isUriSupported(uri.toString()), true);

      /// To convert content uri to file
      print('Convert content URI to file');
      File file = await toFile(uri.toString());

      /// To check file is created
      print('Check file is created');
      expect(file.existsSync(), true);

      /// To delete the file if exist
      if (file.existsSync()) {
        print('Delete converted file');
        file.deleteSync();
      }

      print('');
    });
    */
  });
}
