using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNRate
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNRateModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNRateModule"/>.
        /// </summary>
        internal RNRateModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNRate";
            }
        }
    }
}
