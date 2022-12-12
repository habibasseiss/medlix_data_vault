#import "MedlixDataVaultPlugin.h"
#if __has_include(<medlix_data_vault/medlix_data_vault-Swift.h>)
#import <medlix_data_vault/medlix_data_vault-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "medlix_data_vault-Swift.h"
#endif

@implementation MedlixDataVaultPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMedlixDataVaultPlugin registerWithRegistrar:registrar];
}
@end
