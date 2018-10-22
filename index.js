import { Platform, Linking, NativeModules } from 'react-native'

const AppleNativePrefix = 'itms-apps://itunes.apple.com/app/id'
const AppleWebPrefix = 'https://itunes.apple.com/app/id'
const GooglePrefix = 'http://play.google.com/store/apps/details?id='
const AmazonPrefix = 'amzn://apps/android?p='

export const AndroidMarket = {
  Google: 1,
  Amazon: 2,
  Other: 3,
}

const noop = () => {}

export default class Rate {
  static filterOptions(inputOptions) {
    const options = {
      AppleAppID: '',
      GooglePackageName: '',
      AmazonPackageName: '',
      OtherAndroidURL: '',
      preferredAndroidMarket: AndroidMarket.Google,
      preferInApp: false,
      openAppStoreIfInAppFails: true,
      inAppDelay: 3.0,
      fallbackPlatformURL: '',
    }
    Object.keys(inputOptions).forEach((key) => {
      options[key] = inputOptions[key]
    })
    return options
  }

  static rate(inputOptions, callback = noop) {
    const options = Rate.filterOptions(inputOptions)
    if (Platform.OS === 'ios') {
      options.AppleNativePrefix = AppleNativePrefix
      const { RNRate } = NativeModules
      RNRate.rate(options, (response) => {
        callback(response) // error?
      })
    } else if (Platform.OS === 'android') {
      if (options.preferredAndroidMarket === AndroidMarket.Google) {
        Rate.openURL(GooglePrefix + options.GooglePackageName, callback)
      } else if (options.preferredAndroidMarket === AndroidMarket.Amazon) {
        Rate.openURL(AmazonPrefix + options.AmazonPackageName, callback)
      } else if (options.preferredAndroidMarket === AndroidMarket.Other) {
        Rate.openURL(options.OtherAndroidURL, callback)
      }
    } else {
      Rate.openURL(options.fallbackPlatformURL, callback)
    }
  }

  static openURL(url, callback = noop) {
    Linking.canOpenURL(url).then((supported) => {
      callback(supported)
      if (supported) {
        Linking.openURL(url)
      }
    })
  }
}
