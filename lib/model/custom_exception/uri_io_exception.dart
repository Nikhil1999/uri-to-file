import 'dart:io';

// class for IO related exception
class UriIOException extends IOException {
  /// Description of the error.
  final String? message;

  /// Creates a [UriIOException] with description.
  UriIOException(this.message);

  String toString() => "IOException: $message";
}
