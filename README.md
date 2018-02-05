
# react-native-rate
React Native Rate is a cross platform solution to getting users to easily rate your app.

##### Stores Supported:
Apple App Store | Google Play | Amazon | Other Android Markets | All Others
--- | --- | --- | --- | --- 
**✓** | **✓** | **✓** | **✓** Building your app for a different Android store, you can provide your own URL | **✓** If your platform isn't one of the others, you can input a fallback url to send users to instead


## Getting started

`$ npm install react-native-rate --save`

### Mostly automatic installation

`$ react-native link react-native-rate`

### Manual installation
#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-rate` and add `RNRate.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNRate.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Other Platforms
Android, Windows, etc don't use any native code. So don't worry! (There still is linking to Android if you do react-native link. We only left this here so that we can call native code if there is native code to call someday.)

#### iOS Specific:

Users using iOS 10.3 and above can now use `SKStoreReviewController` to open a Rating Alert right from within their app. There are a few gotchas to using this ReviewController though:
- Users can only rate the app 1-5 stars. They cannot write a review.
- To prevent annoying popups, Apple decides whether or not you can display it, and they do not offer a callback to let you know if it was displayed or not. It is limited to being shown 3-4 times per year.
- If you do want this ReviewController to show up, we wrote a little hack to see if it worked, and if it doesn't, we just open the App Store (using the optional for all devices pre-iOS10.3). Hopefully this hack continues to work, and hopefully Apple updates the API so we don't have to use this hack.
- If you set `options.preferInApp = true`, the popup will happen on appropriate devices the first time you call it after the app is open. The hack used checks the number of windows the application has. For some reason, when the inapp window is dismissed, it is still on the stack. So if you try it again, the popup will appear (if it is 3 or less times you've done it this year), but after a short delay, the App Store will open too.
- Due to all these issues, we recommend only setting preferInApp to true when you are absolutely sure you want a one time, rare chance to ask users to rate your app from within the app. Do not use it to spam them between levels. Do not have a button for rating/reviewing the app, and call this method. And if you want to have a really professional app, save the number of attempts to the device, along with a date. Otherwise you will get some strange behavior.

## Example
```javascript
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
                    let options = {
                        AppleAppID:"2193813192",
                        GooglePackageName:"com.mywebsite.myapp",
                        AmazonPackageName:"com.mywebsite.myapp",
                        OtherAndroidURL:"http://www.randomappstore.com/app/47172391",
                        preferredAndroidMarket: AndroidMarket.Google,
                        preferInApp:false,
                        fallbackPlatformURL:"http://www.mywebsite.com/myapp.html",
                    }
                    Rate.rate(options, (success)=>{
                        if (success) {
                            // this technically only tells us if the user successfully went to the Review Page. Whether they actually did anything, we do not know.
                            this.setState({rated:true})
                        }
                    })
                } />
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
let options = {
    AppleAppID:"2193813192",
}
````

##### Options Example2
```javascript
// Android only, able to target both Google Play & Android stores. You have to write custom build code to find out if the build was for the Amazon App Store, or Google Play
import {androidPlatform} from './buildConstants/androidPlatform' // this is a hypothetical constant created at build time
let options = {
    GooglePackageName:"com.mywebsite.myapp",
    AmazonPackageName:"com.mywebsite.myapp",
    preferredAndroidMarket: androidPlatform == 'google' ? AndroidMarket.Google : AndroidMarket.Amazon
}
```

##### Options Example3
```javascript
// targets only iOS app store and Amazon App Store (not google play or anything else). Also, on iOS, tries to open SKStoreReviewController.
let options = {
    AppleAppID:"2193813192",
    AmazonPackageName:"com.mywebsite.myapp",
    preferredAndroidMarket:AndroidMarket.Amazon,
    preferInApp:true,
}
````

##### Options Example4
```javascript
// targets iOS, Google Play, and Amazon. Also targets Windows, so has a specific URL if Platform isn't ios or android. Like example 2, custom build tools are used to check if built for Google Play or Amazon. Prefers not using InApp rating for iOS.
import {androidPlatform} from './buildConstants/androidPlatform' // this is a hypothetical constant created at build time
let options = {
    AppleAppID:"2193813192",
    GooglePackageName:"com.mywebsite.myapp",
    AmazonPackageName:"com.mywebsite.myapp",
    preferredAndroidMarket: androidPlatform == 'google' ? AndroidMarket.Google : AndroidMarket.Amazon
    fallbackPlatformURL:"ms-windows-store:review?PFN:com.mywebsite.myapp",
}
````

##### Options Example5
```javascript
// targets 4 different android stores: Google Play, Amazon, and 2 fake hypothetical stores: CoolApps and Andrule
import {androidPlatform} from './buildConstants/androidPlatform' // this is a hypothetical constant created at build time
let options = {
    GooglePackageName:"com.mywebsite.myapp",
    AmazonPackageName:"com.mywebsite.myapp",
    preferredAndroidMarket: (androidPlatform == 'google') ? AndroidMarket.Google : (androidPlatform == 'amazon' ? AndroidMarket.Amazon : AndroidMarket.Other),
    OtherAndroidURL:(androidPlatform == 'CoolApps') ? "http://www.coolapps.net/apps/31242342" : "http://www.andrule.com/apps/dev/21312"
}
````

#### About Package Names (Google Play & Android) and Bundle Identifiers (Apple):
If you want to keep the same package name and bundle identifier everwhere, we suggest the following: 
- All lowercase letters
- No numbers
- Use reverse domain style: com.website.appname 

#### Future Plans
I plan to add default support for Windows, but haven't personally built any windows app for a few years now. So will do it when it's actually relevant.
