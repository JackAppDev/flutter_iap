#import "FlutterIapPlugin.h"
#import <flutter_iap/flutter_iap-Swift.h>

@implementation FlutterIapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterIapPlugin registerWithRegistrar:registrar];
}
@end
