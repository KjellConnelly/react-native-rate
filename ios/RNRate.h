
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#import "RCTConvert.h"
#else
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#endif
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface RNRate : NSObject <RCTBridgeModule>

@end
  
