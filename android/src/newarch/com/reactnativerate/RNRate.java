package com.reactnativerate;

import android.os.Build;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Callback;

import com.reactnativerate.NativeRNRateSpec;

public class RNRate extends NativeRNRateSpec {

    private final RNRateImpl delegate;

    public RNRate(ReactApplicationContext reactContext) {
        super(reactContext);
        delegate = new RNRateImpl(reactContext);
    }

    @NonNull
    @Override
    public String getName() {
        return RNRateImpl.NAME;
    }
    
    @Override
    public void rate(ReadableMap options, final Callback callback) {
        delegate.rate(callback);
    }
}