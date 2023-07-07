#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import "React/RCTBridgeModule.h"
#endif

#if RCT_NEW_ARCH_ENABLED
#import <React-Codegen/RNRateSpec/RNRateSpec.h>
#endif

@interface RNRate : NSObject <RCTBridgeModule>
@end

#if RCT_NEW_ARCH_ENABLED
@interface RNRate () <NativeRNRateSpec>
@end
#endif