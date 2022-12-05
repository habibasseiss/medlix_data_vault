#import "MedlixSsoPlugin.h"
#if __has_include(<medlix_sso/medlix_sso-Swift.h>)
#import <medlix_sso/medlix_sso-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "medlix_sso-Swift.h"
#endif

@implementation MedlixSsoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMedlixSsoPlugin registerWithRegistrar:registrar];
}
@end
