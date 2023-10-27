import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

import 'package:uri_to_file/uri_to_file.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await clearTemporaryFiles();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = false, _hasError = false;
  File? _file;

  @override
  void initState() {
    init();
    super.initState();
  }

  /// To init
  void init() {
    _processInitialUri();
    _listenForUri();
  }

  /// To get initial uri
  Future<void> _processInitialUri() async {
    String? uriString = await getInitialLink();
    _processUri(uriString);
  }

  /// To listen for uri
  void _listenForUri() {
    linkStream.listen((uriString) => _processUri(uriString));
  }

  /// To process uri
  Future<void> _processUri(String? uriString) async {
    try {
      if (uriString != null) {
        _hasError = false;
        _isLoading = true;
        setState(() {});
        _file = await toFile(uriString);
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      _hasError = true;
      if (kDebugMode) print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Uri To File Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.00),
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getStepsInfo(),
        _getFileDetails(),
      ],
    );
  }

  Widget _getStepsInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note:',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '-',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                'Open any file from file browser app or any other app and select uri_to_file_example app.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '-',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Text(
                'File opened from file browser app or any other app.\nIt contains content:// uri.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getFileDetails() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  'Opened',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Expanded(
                child: Text(
                  'File Name',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          _getFileName(),
        ],
      ),
    );
  }

  Widget _getFileName() {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: const SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
        ),
      );
    }

    if (_file != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              basename(_file!.path),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            (_hasError) ? 'Error' : 'N/A',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
