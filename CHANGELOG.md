## 0.2.0

- Breaking changes
  - Signature changed for isUriSupported() & toFile() both now requires string uri
- Important note
  - Don't pass uri parameter using [Uri] object via uri.toString(). Because uri.toString() changes the string to lowercase which causes this package to misbehave
  - If you are using uni_links package for deep linking purpose. Pass the uri string using getInitialLink() or linkStream

## 0.1.3

- Added support for uri which are supported by File.fromUri(uri).

## 0.1.2

- Update README.md.

## 0.1.1

- Update file save location.

## 0.1.0

- Initial release.
