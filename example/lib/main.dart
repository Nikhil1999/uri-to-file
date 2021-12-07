import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import 'package:uni_links/uni_links.dart';
import 'package:uri_to_file/uri_to_file.dart';

void main({bool isTesting = false}) {
  runApp(MyApp(
    isTesting: isTesting,
  ));
}

class MyApp extends StatefulWidget {
  final bool isTesting;

  MyApp({this.isTesting = false});

  @override
  _MyAppState createState() => _MyAppState();
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
    if (!widget.isTesting) {
      _processInitialUri();
      _listenForUri();
    } else {
      _mockUri();
    }
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
        if (widget.isTesting) {
          await Future.delayed(Duration(seconds: 5 + Random().nextInt(5)));
        }
        _isLoading = false;
        setState(() {});
      }
    } on UnsupportedError catch (e) {
      Fluttertoast.showToast(msg: 'Uri is not supported');
      _hasError = true;
      print(e.message);
    } on IOException catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      _hasError = true;
      print(e);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: 'Something went wrong. Please try again');
      _hasError = true;
      print(e.toString());
    }
  }

  /// To mock uri (For testing)
  Future<void> _mockUri() async {
    await Future.delayed(Duration(seconds: 5 + Random().nextInt(5)));
    Directory cacheDir = await getTemporaryDirectory();
    File sampleFile =
        File(cacheDir.path + Platform.pathSeparator + 'file_uri_sample.txt');
    sampleFile.createSync();
    await sampleFile.writeAsString('Testing uri_to_file package...');
    Uri uri = Uri.file(sampleFile.path);

    await _processUri(uri.toString());
  }

  /// To get file name
  String _getFileNameString(File? file) {
    return _file?.path.substring(
            (_file?.path.lastIndexOf(Platform.pathSeparator) ?? -1) + 1) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          key: Key('appBar'),
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
      key: Key('stepsInfo'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note:',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '-',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Expanded(
              child: const Text(
                'Open any file from file browser app or any other app and select uri_to_file_example app.',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '-',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Expanded(
              child: const Text(
                'File opened from file browser app or any other app.\nIt contains content:// uri.',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
        key: Key('fileDetails'),
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Expanded(
                child: const Text(
                  'Opened',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                child: const Text(
                  'File Name',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
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
    if (_isLoading)
      return Container(
        key: Key('circularLoader'),
        margin: const EdgeInsets.only(top: 8.0),
        child: const SizedBox(
          width: 16.0,
          height: 16.0,
          child: const CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
        ),
      );

    if (_file != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              _getFileNameString(_file),
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
