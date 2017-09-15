
# react-native-rate
React Native Rate is a cross platform solution to getting users to easily rate your app.

##### Stores Supported:
| Apple App Store | Google Play | Amazon | All Others |
| --------------- | ----------- | ------ | ---------- |
| ✓              |        ✓    |   ✓    |  ✓ If      your platform isn't one of the others, you can input a fallback url to send users to instead    |

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
Android, Windows, etc don't use any native code. So don't worry!

#### iOS Specific:

Users using iOS 10.3 and above can now use `SKStoreReviewController` to open a Rating Alert right from within their app. There are a few gotchas to using this ReviewController though:
- Users can only rate the app 1-5 stars. They cannot write a review.
- To prevent annoying popups, Apple decides whether or not you can display it, and they do not offer a callback to let you know if it was displayed or not. It is limited to being shown 3-4 times per year.
- If you do want this ReviewController to show up, we wrote a little hack to see if it worked, and if it doesn't, we just open the App Store (using the optional for all devices pre-iOS10.3). Hopefully this hack continues to work, and hopefully Apple updates the API so we don't have to use this hack.

## Example
```javascript
import Rate from 'react-native-rate';

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
                        preferGoogle:true,
                        preferInApp:true,
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
| AppleAppID | GooglePackageName | AmazonPackageName | preferGoogle | preferInApp | fallbackPlatformURL |
| -- | --- | -- | --- | -- | --- |
| When you create an app in iTunes Connect, you get a number that is around 10 digits long. | Created when you create an app on Google Play Developer Console. | Create when you create an app on the Amazon Developer Console. | This only matters if you plan to deploy to both Google Play and Amazon. Since there is no reliable way to check at run time where the app was downloaded from, we suggest creating your own build logic to decipher if the app was built for Google Play or Amazon. | If true and user is on iOS, tries to use `SKStoreReviewController`. If fails for whatever reason, or user is on another platform, opens the App Store externally. | `if ((Platform.OS != 'ios) && (Platform.OS != 'android'))`, open this URL. |


##### Options Example1
```javascript
// iOS only, prefers in-app rating (this is the default)
let options = {
    AppleAppID:"2193813192",
}
````

##### Options Example2
```javascript
// Android only, able to target both Google Play & Android stores. You have to write custom build code to find out if the build was for the Amazon App Store, or Google Play
let options = {
    GooglePackageName:"com.mywebsite.myapp",
    AmazonPackageName:"com.mywebsite.myapp",
    preferGoogle:this.state.androidPlatform == 'google',
}
```

##### Options Example3
```javascript
// targets only iOS app store and Amazon App Store (not google play). Also, on iOS, doesn't open SKStoreReviewController. 
let options = {
    AppleAppID:"2193813192",
    AmazonPackageName:"com.mywebsite.myapp",
    preferGoogle:false,
    preferInApp:false,
}
````

##### Options Example4
```javascript
// targets iOS, Google Play, and Amazon. Also targets Windows, so has a specific URL if Platform isn't ios or android. Like example 2, custom build tools are used to check if built for Google Play or Amazon. Prefers inapp rating for iOS.
let options = {
    AppleAppID:"2193813192",
    GooglePackageName:"com.mywebsite.myapp",
    AmazonPackageName:"com.mywebsite.myapp",
    preferGoogle:this.state.androidPlatform == 'google',
    fallbackPlatformURL:"ms-windows-store:review?PFN:com.mywebsite.myapp",
}
````

#### About Package Names (Google Play & Android) and Bundle Identifiers (Apple):
If you want to keep the same package name and bundle identifier everwhere, we suggest the following: 
- All lowercase letters
- No numbers
- Use reverse domain style: com.website.appname 

#### Future Plans
I plan to add default support for Windows, but haven't personally built any windows app for a few years now. So will do it when it's actually relevant.
