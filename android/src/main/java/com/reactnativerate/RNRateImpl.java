package com.reactnativerate;

import android.app.Activity;
import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;

import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;

class RNRateImpl {

    public static final String NAME = "RNRate";

    static ReactApplicationContext RCTContext;

    public RNRateImpl(ReactApplicationContext reactContext) {
        RCTContext = reactContext;
    }

    public void rate(final Callback callback) {
        final Activity activity = RCTContext.getCurrentActivity();

        if (activity != null) {
            final ReviewManager manager = ReviewManagerFactory.create(RCTContext);
            Task<ReviewInfo> request = manager.requestReviewFlow();
            request.addOnCompleteListener(new OnCompleteListener<ReviewInfo>() {
                @Override
                public void onComplete(@NonNull final Task<ReviewInfo> requestTask) {
                    if (requestTask.isSuccessful()) {
                        ReviewInfo reviewInfo = requestTask.getResult();
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
        } else {
            callback.invoke(false, "getCurrentActivity() unsuccessful");
        }
    }
}