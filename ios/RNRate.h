
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else // Compatibility for RN version < 0.40
#import "RCTBridgeModule.h"
#endif

#if __has_include(<React/RCTConvert.h>)
#import <React/RCTConvert.h>
#else // Compatibility for RN version < 0.40
#import "RCTConvert.h"
#endif

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface RNRate : NSObject <RCTBridgeModule>

@end
  
