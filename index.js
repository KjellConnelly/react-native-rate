import {Platform, Linking, NativeModules} from 'react-native'

const AppleNativePrefix = "itms-apps://itunes.apple.com/app/id"
const AppleWebPrefix = "https://itunes.apple.com/app/id"
const GooglePrefix = "http://play.google.com/store/apps/details?id="
const AmazonPrefix = "amzn://apps/android?p="

export default class Rate {
	static filterOptions(inputOptions) {
		let options = {
			AppleAppID:"",
			GooglePackageName:"",
			AmazonPackageName:"",
			preferGoogle:true,
			preferInApp:true,
      fallbackPlatformURL:"",
		}
		Object.keys(inputOptions).forEach(function(key) {
			options[key] = inputOptions[key]
		})
		return options
	}

	static rate(inputOptions, callback) {
		let options = Rate.filterOptions(inputOptions)
		if (Platform.OS == 'ios') {
      options.AppleNativePrefix = AppleNativePrefix
			const RNRate = NativeModules.RNRate
			RNRate.rate(options, response=>{
				callback(response) // error?
			})
		} else if (Platform.OS == 'android') {
			if (options.preferGoogle) {
				Rate.openURL(GooglePrefix + options.GooglePackageName, callback)
			} else {
				Rate.openURL(AmazonPrefix + options.AmazonPackageName, callback)
			}
		} else {
			Rate.openURL(options.fallbackPlatformURL, callback)
		}
	}

	static openURL(url, callback) {
	Linking.canOpenURL(url).then(supported => {
		callback(supported)
      if (supported)
        Linking.openURL(url)
		)
    })
	}
}
