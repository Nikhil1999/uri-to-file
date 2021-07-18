# uri_to_file

A Flutter plugin for converting uri to file. Supports Android.

**Supported Uri Schema**

1. content://

## Get started

### Add dependency

```yaml
dependencies:
  uri_to_file: ^0.1.0
```

### Super simple to use

```dart
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:uri_to_file/uri_to_file.dart';

void getFile() async {
  try {
    String uri = 'content://sample.txt';
    File file = await UriToFile.toFile(uri);
  } on PlatformException catch (e) {
    switch (e.code) {
      case UriToFile.URI_NOT_SUPPORTED:
        {
          print(e.message); // For uri not supported
          break;
        }
      case UriToFile.IO_EXCEPTION:
        {
          print(e.message); // For IO exception
          break;
        }
      default:
        {
          print(e.message); // For default exception
          break;
        }
    }
  } on Exception catch (e) {
    print(e); // For default exception
  }
}
```

## Copyright & License

MIT License

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Nikhil1999/uri-to-file/issues
