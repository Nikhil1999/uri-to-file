import 'package:flutter_driver/driver_extension.dart';
import '../lib/main.dart' as app;

/// To perform integration testing
///
/// Run:
/// flutter drive --target=test_driver/app.dart
void main() {
  // To enable flutter driver extension
  enableFlutterDriverExtension();

  // To run the app in testing mode
  app.main(isTesting: true);
}
