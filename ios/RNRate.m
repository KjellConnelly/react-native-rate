
#import "RNRate.h"

@implementation RNRate
RCTResponseSenderBlock savedCallback;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(rate: (NSDictionary *)options : (RCTResponseSenderBlock) callback) {
    
    NSString *AppleAppID = [RCTConvert NSString:options[@"AppleAppID"]];
    NSString *AppleNativePrefix = [RCTConvert NSString:options[@"AppleNativePrefix"]];
    BOOL *preferInApp = [RCTConvert BOOL:options[@"preferInApp"]];
    
    NSString *suffix = @"?action=write-review";
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@", AppleNativePrefix, AppleAppID, suffix];
    
    if (preferInApp) {
        if ([SKStoreReviewController class]) {
            NSUInteger windowCount = [[[UIApplication sharedApplication] windows] count];
            
            [SKStoreReviewController requestReview];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (windowCount <= [[[UIApplication sharedApplication] windows] count]) {
                    [self openAppStoreAndRate:url];
                }
                callback(@[[NSNumber numberWithBool:true]]);
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

- (void) openAppStoreAndRate : (NSString *) url {
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
}



@end
