import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  rate: (options:{ // those are the options that are actually truly used on native side
    AppleAppID: string,
    AppleNativePrefix: string,
    preferInApp: boolean,
    inAppDelay: number,
    openAppStoreIfInAppFails: boolean
  }, callback:(success:boolean, error:string) => void) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('RNRate');