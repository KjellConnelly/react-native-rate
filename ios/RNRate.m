#import "RNRate.h"

@implementation RNRate
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(rate: (NSDictionary *)options : (RCTResponseSenderBlock) callback) {
    NSString *AppleAppID = [RCTConvert NSString:options[@"AppleAppID"]];
    NSString *AppleNativePrefix = [RCTConvert NSString:options[@"AppleNativePrefix"]];
    BOOL preferInApp = [RCTConvert BOOL:options[@"preferInApp"]];
    float inAppDelay = [RCTConvert float:options[@"inAppDelay"]];
    
    
    NSString *suffix = @"?action=write-review";
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", AppleNativePrefix, AppleAppID, suffix];
    
    if (preferInApp) {
        if ([SKStoreReviewController class]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUInteger windowCount = [[[UIApplication sharedApplication] windows] count];
                [SKStoreReviewController requestReview];
                
                float checkTime = 0.1;
                int iterations = (int)(inAppDelay / checkTime);
                
                [self possiblyOpenAppStore:url :windowCount :callback :checkTime :iterations];
            });
        } else {
            [self openAppStoreAndRate:url];
            callback(@[[NSNumber numberWithBool:true]]);
        }
    } else {
        [self openAppStoreAndRate:url];
        callback(@[[NSNumber numberWithBool:true]]);
    }
}

- (void) possiblyOpenAppStore : (NSString *) url : (NSUInteger) originalWindowCount : (RCTResponseSenderBlock) callback : (float) checkTime : (int) iterations {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(checkTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUInteger newWindowCount = [[[UIApplication sharedApplication] windows] count];
        
        if (newWindowCount > originalWindowCount) {
            callback(@[[NSNumber numberWithBool:true]]);
        } else if (newWindowCount < originalWindowCount) {
            callback(@[[NSNumber numberWithBool:false]]);
        } else {
            int newInterations = iterations - 1;
            if (newInterations > 0) {
                [self possiblyOpenAppStore:url :originalWindowCount :callback :checkTime :newInterations];
            } else {
                [self openAppStoreAndRate:url];
                callback(@[[NSNumber numberWithBool:true]]);
            }
        }
    });
}

- (void) openAppStoreAndRate : (NSString *) url {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
}



@end
