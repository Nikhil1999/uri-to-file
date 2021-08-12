import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('uri_to_file:', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    /// To check flutter driver health
    test('Check Flutter Driver Health', () async {
      Health health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    /// To find app bar
    test('Find App Bar', () async {
      await driver.waitFor(find.byValueKey('appBar'),
          timeout: Duration(seconds: 5));
    });

    /// To find steps info
    test('Find Steps Info', () async {
      await driver.waitFor(find.byValueKey('stepsInfo'),
          timeout: Duration(seconds: 5));
    });

    /// To find file details
    test('Find File Details', () async {
      await driver.waitFor(find.byValueKey('fileDetails'),
          timeout: Duration(seconds: 5));
    });

    /// To find N/A
    test('Find N/A', () async {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(find.text('N/A'), timeout: Duration(seconds: 20));
        await driver.waitForAbsent(find.text('N/A'),
            timeout: Duration(seconds: 20));
      });
    }, timeout: Timeout.none);

    /// To find circular loader
    test('Find Circular Loader', () async {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(find.byValueKey('circularLoader'),
            timeout: Duration(seconds: 20));
        await driver.waitForAbsent(find.byValueKey('circularLoader'),
            timeout: Duration(seconds: 20));
      });
    });

    /// To find file name
    test('Find File Name', () async {
      await driver.runUnsynchronized(() async {
        await driver.waitFor(find.text('file_uri_sample.txt'),
            timeout: Duration(seconds: 20));
      });
    });

    tearDownAll(() async {
      await driver.close();
    });
  });
}
