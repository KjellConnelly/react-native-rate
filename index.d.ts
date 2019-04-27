declare module 'react-native-rate' {
  export interface IConfig {
    AppleAppID?: string,
    GooglePackageName?: string,
    AmazonPackageName?: string,
    OtherAndroidURL?: string,
    preferredAndroidMarket?: AndroidMarket,
    preferInApp?: boolean,
    openAppStoreIfInAppFails?: boolean,
    inAppDelay?: number,
    fallbackPlatformURL?: string,
  }

  export enum AndroidMarket {
    Google,
    Amazon,
    Other,
  }

  export default class Rate {
    static rate(config: IConfig, callback: (success: boolean) => void): void;
  }
}
