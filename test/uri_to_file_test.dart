import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uri_to_file/uri_to_file.dart';

void main() {
  const MethodChannel channel =
      MethodChannel('in.lazymanstudios.uritofile/helper');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'fromUri':
          {
            File file = File('sample_test.txt');
            file.createSync();
            return file.path;
          }
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('Test toFile()', () async {
    File file = await UriToFile.toFile('content://sample_test.txt');

    // To test file is exist
    expect(file.existsSync(), true);

    // To delete the file if exist
    if (file.existsSync()) {
      file.deleteSync();
    }
  });
}
