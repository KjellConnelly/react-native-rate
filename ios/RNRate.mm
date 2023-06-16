#import "RNRate.h"
#import "UIKit/UIKit.h"

#import "React/RCTConvert.h"
#import "StoreKit/StoreKit.h"

#if RCT_NEW_ARCH_ENABLED
#import <RNRateSpec/RNRateSpec.h>
#endif


@implementation RNRate

RCT_EXPORT_MODULE(RNRate);

#if RCT_NEW_ARCH_ENABLED
- (void)rate:(JS::NativeRNRate::SpecRateOptions &)options callback:(RCTResponseSenderBlock)callback {
    NSLog(@"new arch rate called");
    NSString *AppleAppID = options.AppleAppID();
    NSString *AppleNativePrefix = options.AppleNativePrefix();
    BOOL preferInApp = options.preferInApp();
    float inAppDelay = options.inAppDelay();
    BOOL openAppStoreIfInAppFails = options.openAppStoreIfInAppFails();
    
    [self rateImpl:AppleAppID :AppleNativePrefix :preferInApp :inAppDelay :openAppStoreIfInAppFails :callback];
}
#else
RCT_EXPORT_METHOD(rate: (NSDictionary *)options : (RCTResponseSenderBlock) callback) {
    NSLog(@"old arch rate called");
    
    NSString *AppleAppID = [RCTConvert NSString:options[@"AppleAppID"]];
    NSString *AppleNativePrefix = [RCTConvert NSString:options[@"AppleNativePrefix"]];
    BOOL preferInApp = [RCTConvert BOOL:options[@"preferInApp"]];
    float inAppDelay = [RCTConvert float:options[@"inAppDelay"]];
    BOOL openAppStoreIfInAppFails = [RCTConvert BOOL:options[@"openAppStoreIfInAppFails"]];

    [self rateImpl:AppleAppID :AppleNativePrefix :preferInApp :inAppDelay :openAppStoreIfInAppFails :callback];
}
#endif

- (void) rateImpl: (NSString *) AppleAppID : (NSString *) AppleNativePrefix : (BOOL) preferInApp : (float) inAppDelay : (BOOL) openAppStoreIfInAppFails : (RCTResponseSenderBlock) callback {
    NSLog(@"rateImpl ");
    NSLog(@"AppleAppID %@",AppleAppID);
    NSLog(@"AppleNativePrefix %@",AppleNativePrefix);
    NSLog(@"preferInApp %d",preferInApp);
    NSLog(@"inAppDelay %f",inAppDelay);
    NSLog(@"openAppStoreIfInAppFails %d",openAppStoreIfInAppFails);
    
    NSString *suffix = @"?action=write-review";

    NSString *url = [NSString stringWithFormat:@"%@%@%@", AppleNativePrefix, AppleAppID, suffix];

    if (preferInApp) {
        if ([SKStoreReviewController class]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSUInteger windowCount = [[[UIApplication sharedApplication] windows] count];

                if (@available(iOS 14.0, *)) {
                    NSSet *scenes = [[UIApplication sharedApplication] connectedScenes];
                    NSArray *scenesArray = [scenes allObjects];

                    UIWindowScene *activeScene;
                    for (int i = 0; i < scenes.count; i++) {
                        UIWindowScene *scene = [scenesArray objectAtIndex:i];
                        NSInteger activationState = scene.activationState;
                        if (activationState == UISceneActivationStateForegroundActive) {
                            activeScene = scene;
                        }
                    }

                    if (activeScene != nil) {
                        [SKStoreReviewController requestReviewInScene:activeScene];
                    } else {
                        // If you get here, it's because there is no active scene for whatever reason.
                        // I'm not sure if this is a react-native thing, but I'd assume there is
                        // always an active scene. I'm not interested in debugging right now,
                        // so I'm just adding a NSLog for now. Should just open in App Store.
                        NSLog(@"No active scenes found. Cannot requestReviewInScene.");
                    }
                } else {
                    [SKStoreReviewController requestReview];
                }

                float checkTime = 0.1;
                int iterations = (int)(inAppDelay / checkTime);

                [self possiblyOpenAppStore:url :windowCount :callback :checkTime :iterations :openAppStoreIfInAppFails];
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

- (void) possiblyOpenAppStore : (NSString *) url : (NSUInteger) originalWindowCount : (RCTResponseSenderBlock) callback : (float) checkTime : (int) iterations : (BOOL) openAppStoreIfInAppFails {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(checkTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUInteger newWindowCount = [[[UIApplication sharedApplication] windows] count];

        if (newWindowCount > originalWindowCount) {
            callback(@[[NSNumber numberWithBool:true]]);
        } else if (newWindowCount < originalWindowCount) {
            callback(@[[NSNumber numberWithBool:false]]);
        } else {
            int newInterations = iterations - 1;
            if (newInterations > 0) {
                [self possiblyOpenAppStore:url :originalWindowCount :callback :checkTime :newInterations :openAppStoreIfInAppFails];
            } else {
                if (openAppStoreIfInAppFails) {
                  [self openAppStoreAndRate:url];
                  callback(@[[NSNumber numberWithBool:true]]);
                } else {
                  callback(@[[NSNumber numberWithBool:false]]);
                }
            }
        }
    });
}

- (void) openAppStoreAndRate : (NSString *) url {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
  });
}

# pragma mark - New Architecture
#if RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRNRateSpecJSI>(params);
}
#endif

@end
