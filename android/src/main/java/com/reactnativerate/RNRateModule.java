package com.reactnativerate;

import android.app.Activity;
import androidx.annotation.NonNull;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Callback;
import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import com.google.android.play.core.tasks.OnCompleteListener;
import com.google.android.play.core.tasks.Task;



public class RNRateModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNRateModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNRate";
    }

    @ReactMethod
    public void rate(ReadableMap options, final Callback callback) {
        final ReviewManager manager = ReviewManagerFactory.create(this.reactContext);
        Task<ReviewInfo> request = manager.requestReviewFlow();
        request.addOnCompleteListener(new OnCompleteListener<ReviewInfo>() {
            @Override
            public void onComplete(@NonNull final Task<ReviewInfo> requestTask) {
                if (requestTask.isSuccessful()) {
                    ReviewInfo reviewInfo = requestTask.getResult();
                    Activity activity = getCurrentActivity();
                    if (activity == null) {
                        callback.invoke(false, "getCurrentActivity() unsuccessful");
                        return;
                    }
                    Task<Void> flow = manager.launchReviewFlow(activity, reviewInfo);
                    flow.addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull Task<Void> flowTask) {
                            if (requestTask.isSuccessful()) {
                                callback.invoke(true);
                            } else {
                                callback.invoke(false, "launchReviewFlow() unsuccessful");
                            }
                        }
                    });
                } else {
                    callback.invoke(false, "requestReviewFlow() unsuccessful");
                }
            }
        });
    }
}
