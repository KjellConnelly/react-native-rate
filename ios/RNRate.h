
#if __has_include(<React/RCTBridgeModule.h>)
 // React Native >= 0.40
 #import <React/RCTBridgeModule.h>
 #import <React/RCTConvert.h>
#else
 // React Native <= 0.39
 #import "RCTBridgeModule.h" 
 #import "RCTConvert.h"
#endif

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface RNRate : NSObject <RCTBridgeModule>

@end
  
