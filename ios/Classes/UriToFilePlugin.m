#import "UriToFilePlugin.h"
#if __has_include(<uri_to_file/uri_to_file-Swift.h>)
#import <uri_to_file/uri_to_file-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "uri_to_file-Swift.h"
#endif

@implementation UriToFilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUriToFilePlugin registerWithRegistrar:registrar];
}
@end
