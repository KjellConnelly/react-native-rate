
# react-native-rate
React Native Rate is a cross platform solution to getting users to easily rate your app.

##### Stores Supported:
Apple App Store | Google Play | Amazon | Other Android Markets | All Others
--- | --- | --- | --- | ---
**✓** | **✓** | **✓** | **✓** Building your app for a different Android store, you can provide your own URL | **✓** If your platform isn't one of the others, you can input a fallback url to send users to instead


## Getting started

`$ npm install react-native-rate --save`

### Mostly automatic installation (new way with react-native v0.60+)
`cd ios && pod install && cd ../`

### Mostly automatic installation (old way)

`$ react-native link react-native-rate`

### Manual installation
#### iOS

##### Without CocoaPods
1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-rate` and add `RNRate.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNRate.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

##### Using CocoaPods

Add the following to your `Podfile` (and run `pod install`):
```
pod 'RNRate', :path => '../node_modules/react-native-rate'
```

#### Other Platforms
Android, Windows, etc don't use any native code. So don't worry! (There still is linking to Android if you do react-native link. We only left this here so that we can call native code if there is native code to call someday.)

#### iOS Specific:

Users using iOS 10.3 and above can now use `SKStoreReviewController` to open a Rating Alert right from within their app. There are a few gotchas to using this ReviewController though:
- Users are first presented with a pop up allowing them to choose 1-5 stars. If they give a numerical rating, the pop up will allow them to then write a review. They can cancel at any time, leaving you with either nothing, a rating, or a rating and review.
- To prevent annoying popups, Apple decides whether or not you can display it, and they do not offer a callback to let you know if it was displayed or not. It is limited to being shown 3-4 times per year.
- If you do want this ReviewController to show up, we wrote a little hack to see if it worked, and if it doesn't, we just open the App Store (using the optional for all devices pre-iOS10.3). Hopefully this hack continues to work, and hopefully Apple updates the API so we don't have to use this hack.
- If you set `options.preferInApp = true`, the popup will happen on appropriate devices the first time you call it after the app is open. The hack used checks the number of windows the application has. For some reason, when the inapp window is dismissed, it is still on the stack. So if you try it again, the popup will appear (if it is 3 or less times you've done it this year), but after a short delay, the App Store will open too.
- Due to all these issues, we recommend only setting preferInApp to true when you are absolutely sure you want a one time, rare chance to ask users to rate your app from within the app. Do not use it to spam them between levels. Do not have a button for rating/reviewing the app, and call this method. And if you want to have a really professional app, save the number of attempts to the device, along with a date. Otherwise you will get some strange behavior.
- If you want to open via the `SKStoreReviewController`, but don't want the App Store App to open after the timeout, you can set `openAppStoreIfInAppFails:false` in options. By default, it will open after the timeout.

## Example
```javascript
import React from 'react'
import { View, Button } from 'react-native'
import Rate, { AndroidMarket } from 'react-native-rate'

export default class ExamplePage extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      rated: false
    }
  }

  render() {
    return (
      <View>
        <Button title="Rate App" onPress={()=>{
          const options = {
            AppleAppID:"2193813192",
            GooglePackageName:"com.mywebsite.myapp",
            AmazonPackageName:"com.mywebsite.myapp",
            OtherAndroidURL:"http://www.randomappstore.com/app/47172391",
            preferredAndroidMarket: AndroidMarket.Google,
            preferInApp:false,
            openAppStoreIfInAppFails:true,
            fallbackPlatformURL:"http://www.mywebsite.com/myapp.html",
          }
          Rate.rate(options, success=>{
            if (success) {
              // this technically only tells us if the user successfully went to the Review Page. Whether they actually did anything, we do not know.
              this.setState({rated:true})
            }
          })
        }} />
      </View>
    )
  }
}
```

#### options:
There are lots of options. You can ignore some of them if you don't plan to have them on that App Store.

| AppleAppID | GooglePackageName | AmazonPackageName | preferredAndroidMarket | preferInApp | fallbackPlatformURL | inAppDelay |
| -- | --- | -- | --- | -- | --- | --- |
| When you create an app in iTunes Connect, you get a number that is around 10 digits long. | Created when you create an app on Google Play Developer Console. | Create when you create an app on the Amazon Developer Console. | This only matters if you plan to deploy to both Google Play and Amazon or other markets. Since there is no reliable way to check at run time where the app was downloaded from, we suggest creating your own build logic to decipher if the app was built for Google Play or Amazon, or Other markets. Available Options: AndroidMarket.Google, AndroidMarket.Amazon, Other | If true and user is on iOS, tries to use `SKStoreReviewController`. If fails for whatever reason, or user is on another platform, opens the App Store externally. | `if ((Platform.OS != 'ios) && (Platform.OS != 'android'))`, open this URL. | (IOS ONLY) Delay to wait for the InApp review dialog to show (if preferInApp == true). After delay, opens the App Store if the InApp review doesn't show. Default 3.0 |


##### Options Example1
```javascript
// iOS only, not using in-app rating (this is the default)
const options = {
  AppleAppID:"2193813192",
}
```

##### Options Example2
```javascript
// Android only, able to target both Google Play & Amazon stores. You have to write custom build code to find out if the build was for the Amazon App Store, or Google Play
import {androidPlatform} from './buildConstants/androidPlatform' // this is a hypothetical constant created at build time
const options = {
  GooglePackageName:"com.mywebsite.myapp",
  AmazonPackageName:"com.mywebsite.myapp",
  preferredAndroidMarket: androidPlatform == 'google' ? AndroidMarket.Google : AndroidMarket.Amazon
}
```

##### Options Example3
```javascript
// targets only iOS app store and Amazon App Store (not google play or anything else). Also, on iOS, tries to open SKStoreReviewController.
const options = {
  AppleAppID:"2193813192",
  AmazonPackageName:"com.mywebsite.myapp",
  preferredAndroidMarket:AndroidMarket.Amazon,
  preferInApp:true,
}
```

##### Options Example4
```javascript
// targets iOS, Google Play, and Amazon. Also targets Windows, so has a specific URL if Platform isn't ios or android. Like example 2, custom build tools are used to check if built for Google Play or Amazon. Prefers not using InApp rating for iOS.
import {androidPlatform} from './buildConstants/androidPlatform' // this is a hypothetical constant created at build time
const options = {
  AppleAppID:"2193813192",
  GooglePackageName:"com.mywebsite.myapp",
  AmazonPackageName:"com.mywebsite.myapp",
  preferredAndroidMarket: androidPlatform == 'google' ? AndroidMarket.Google : AndroidMarket.Amazon
  fallbackPlatformURL:"ms-windows-store:review?PFN:com.mywebsite.myapp",
}
```

##### Options Example5
```javascript
// targets 4 different android stores: Google Play, Amazon, and 2 fake hypothetical stores: CoolApps and Andrule
import {androidPlatform} from './buildConstants/androidPlatform' // this is a hypothetical constant created at build time
const options = {
  GooglePackageName:"com.mywebsite.myapp",
  AmazonPackageName:"com.mywebsite.myapp",
  preferredAndroidMarket: (androidPlatform == 'google') ? AndroidMarket.Google : (androidPlatform == 'amazon' ? AndroidMarket.Amazon : AndroidMarket.Other),
  OtherAndroidURL:(androidPlatform == 'CoolApps') ? "http://www.coolapps.net/apps/31242342" : "http://www.andrule.com/apps/dev/21312"
}
```

##### Options Example6
```javascript
// Tries to open the SKStoreReviewController in app for iOS only, but if it fails, nothing happens instead of opening the App Store app after 5.0s. Technically, you do not need to add inAppDelay in options below because it has a default value. I am only writing it below to show the difference between openAppStoreIfInAppFails true/false values and what would happen after the inAppDelay.
const options = {
  AppleAppID:"2193813192",
  preferInApp:true,
  inAppDelay:5.0,
  openAppStoreIfInAppFails:false,
}
```

#### About Package Names (Google Play & Android) and Bundle Identifiers (Apple):
If you want to keep the same package name and bundle identifier everwhere, we suggest the following:
- All lowercase letters
- No numbers
- Use reverse domain style: com.website.appname

#### I’m new to mobile development. Why is rating important?
Though this isn’t specific to this module, some new developers are not quite sure why rating is important.

First off, rating and reviews are technically two different things. Rating being typically a 1-5 star rating, and a review being text that a user writes. Both are important for different reasons.

A higher rating increases your app’s chance of being shown in search results. Some even think that ANY rating will increase your app’s chance, though I don’t know the algorithm. Some users
also look at stars and weigh their decision to download or not partially on this metric.

Likewise, reviews give both developers and users good feedback on how the app is doing. Developers can use these reviews as quotes in their app description, and in some stores even reply to reviews (iOS, Google Play, Amazon, and possibly others).

Getting good reviews and good ratings will increase your app’s popularity and downloads. Of course, getting a user to rate your app is mainly about maximizing your probability of success, vs annoying them. There are a lot of articles online on how best to get users to rate your app, but we won’t go into them here.

Your job as the developer, using this module, is to create an experience for the user, and at the right time, ask them to rate. This can be in the form of a pop up, a perpetual button on a settings menu, or after being a level in a game. It’s up to you.

#### What this module does when you call rate()

For those that don’t want to read through the code, this module will open a link to the App Store of your choosing based on your options and user’s device. The App Store will be on your app’s page. If possible, it will be on the Ratings/Reviews section.

If possible, the App Store will be opened in the native app for the Store (ie the App Store app). If not possible, it will be opened from the user’s browser.

The only time when the above is not true is for iOS when you setup your options to use the `SKStoreReviewController`. In this case, a native UI pop up (created by Apple) is displayed from within you app.

#### Rate.rate() success?

Success in most cases is self explanatory. But for the iOS `SKStoreReviewController` case:

--- | success | !success
--- | --- | ---
`{preferInApp:true}` and the SKStoreReviewController successfully opens | **✓** | ---
`{preferInApp:true, openAppStoreIfInAppFails:true}` and the SKStoreReviewController fails to open, but opens the App Store App | **✓** | ---
`{preferInApp:true, openAppStoreIfInAppFails:false}` and the SKStoreReviewController fails to open, and does not open the App Store App | --- | **✓**

#### This used to work, now I'm getting an error message with react-native-rate v1.2.0
I moved the podspec file outside of the `ios` directory. If you use pods before this version, you may have set paths to `ios/RNRate.podspec`. You may need to change that back.

#### Future Plans
I plan to add default support for Windows, but haven't personally built any windows app for a few years now. So will do it when it's actually relevant.
