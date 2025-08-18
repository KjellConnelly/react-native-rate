package com.reactnativerate;

import android.app.Activity;
import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Callback;
import com.facebook.react.module.annotations.ReactModule;
import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

@ReactModule(name = RNRateImpl.NAME)
public class RNRate extends ReactContextBaseJavaModule {

    private final RNRateImpl delegate;
    
    public RNRate(ReactApplicationContext reactContext) {
        super(reactContext);
        delegate = new RNRateImpl(reactContext);
    }

    @Override
    public String getName() {
        return RNRateImpl.NAME;
    }

    @ReactMethod
    public void rate(ReadableMap options, final Callback callback) {
        delegate.rate(callback);
    }
}
