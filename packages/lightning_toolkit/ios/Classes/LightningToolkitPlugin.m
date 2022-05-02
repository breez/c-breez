#import "LightningToolkitPlugin.h"
#import "bridge_generated.h"
#if __has_include(<lightning_toolkit/lightning_toolkit-Swift.h>)
#import <lightning_toolkit/lightning_toolkit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lightning_toolkit-Swift.h"
#endif

@implementation LightningToolkitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLightningToolkitPlugin registerWithRegistrar:registrar];
  dummy_method_to_enforce_bundling();
}
@end
