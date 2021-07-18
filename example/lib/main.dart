import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _isLoading = false, _hasError = false;
  File? _file;

  @override
  void initState() {
    _processInitialUri();
    _listenForUri();
    super.initState();
  }

  void _processInitialUri() async {
    Uri? uri = await getInitialUri();
    if (uri != null) {
      _processUri(uri);
    }
  }

  void _listenForUri() async {
    uriLinkStream.listen((uri) {
      if (uri != null) {
        _processUri(uri);
      }
    });
  }

  void _processUri(Uri? uri) async {
    try {
      if (uri != null) {
        _hasError = false;
        _isLoading = true;
        setState(() {});
        _file = await UriToFile.toFile(uri.toString());
        _isLoading = false;
        setState(() {});
      }
    } on PlatformException catch (e) {
      _hasError = true;
      switch (e.code) {
        case UriToFile.URI_NOT_SUPPORTED:
          {
            print(e.message);
            break;
          }
        case UriToFile.IO_EXCEPTION:
          {
            print(e.message);
            break;
          }
        default:
          {
            print(e.message);
            break;
          }
      }
    } on Exception catch (e) {
      _hasError = true;
      print(e.toString());
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
          padding: EdgeInsets.all(16.00),
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
        Text(
          'Note:',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          children: [
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
            children: [
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
            children: [
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
    if (_isLoading)
      return Container(
        margin: EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: 16.0,
          height: 16.0,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
        ),
      );

    if (_file != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              _file?.path.substring(
                      (_file?.path.lastIndexOf(Platform.pathSeparator) ?? -1) +
                          1) ??
                  '',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
