import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uri_to_file/uri_to_file.dart';

void main() {
  const MethodChannel channel = MethodChannel('uri_to_file');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await UriToFile.platformVersion, '42');
  });
}
