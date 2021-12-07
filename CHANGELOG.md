## 0.2.0

- Breaking changes
  - isUriSupported() & toFile() both requires string uri
- Important note
  - Don't pass uri parameter value using [Uri] object via uri.toString() method. Because [Uri] object changes the authority name to lower case which causes this package to misbehave
  - If you are using uni_links package for deep linking purpose.
    Pass the uri string value using getInitialLink() or linkStream

## 0.1.3

- Added support for uri which are supported by File.fromUri(uri).

## 0.1.2

- Update README.md.

## 0.1.1

- Update file save location.

## 0.1.0

- Initial release.
