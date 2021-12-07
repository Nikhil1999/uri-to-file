# uri_to_file

[![Pub](https://img.shields.io/pub/v/uri_to_file.svg?style=flat-square&logo=dart&label=pub.dev&color=blue)](https://pub.dev/packages/uri_to_file)

A Flutter plugin for converting supported uri to file. Supports Android & iOS.

**Supported Uri Schema**

- content:// (Android Only)
- Schema supported by File.fromUri(uri)

## Get started

### Add dependency

```yaml
dependencies:
  uri_to_file: ^0.1.3
```

### Super simple to use

```dart
import 'dart:io';

import 'package:uri_to_file/uri_to_file.dart';

Future<void> convertUriToFile() async {
  try {
    String uriString = 'content://sample.txt'; // Uri string

    // Don't pass uri parameter value using [Uri] object via uri.toString() method
    // Because [Uri] object changes the authority name to lower case which causes this package to misbehave

    // If you are using uni_links package for deep linking purpose.
    // Pass the uri string value using getInitialLink() or linkStream

    // Check out the full example
    // https://pub.dev/packages/uri_to_file/example

    File file = await toFile(uriString); // Converting uri to file
  } on UnsupportedError catch (e) {
    print(e.message); // Unsupported error for uri not supported
  } on IOException catch (e) {
    print(e); // IOException for system error
  } catch (e) {
    print(e); // General exception
  }
}
```

### Working example

![Working example](https://raw.githubusercontent.com/Nikhil1999/uri-to-file/dev/example/output/Output.gif 'Working example')

### Background

- **content:// (Android Only)**
  uri_to_file creates a temporary file using the content:// uri with the help of native channel that stores this file in the application directory.

- All the others uri are handled by flutter sdk itself with the help of
  **File.fromUri(uri)**

## Copyright & License

MIT License

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Nikhil1999/uri-to-file/issues
