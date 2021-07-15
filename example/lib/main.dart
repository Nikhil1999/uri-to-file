import 'dart:io';

import 'package:flutter/material.dart';

import 'package:uni_links/uni_links.dart';
import 'package:uri_to_file/uri_to_file.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String message = '';

  @override
  void initState() {
    getInitialUri().then((value) async {
      int i;
      if (value != null) {
        try {
          File file = await UriToFile.toFile(value.toString());
          message = file.path;
          int i;
        } catch (e) {
          message = 'Exception';
          int i;
        }
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uri To File'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
