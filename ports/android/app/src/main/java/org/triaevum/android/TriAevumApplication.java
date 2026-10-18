package org.triaevum.android;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.view.View;

/** Android application host for lifecycle-safe UI configuration. */
public final class TriAevumApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override public void onActivityCreated(Activity activity, Bundle state) {
                apply(activity);
            }
            @Override public void onActivityResumed(Activity activity) {
                apply(activity);
            }
            @Override public void onActivityPostCreated(Activity activity, Bundle state) {
                apply(activity);
            }
            @Override public void onActivityPostResumed(Activity activity) {
                apply(activity);
            }
            @Override public void onActivityStarted(Activity activity) { }
            @Override public void onActivityPostStarted(Activity activity) { }
            @Override public void onActivityPaused(Activity activity) { }
            @Override public void onActivityPostPaused(Activity activity) { }
            @Override public void onActivityStopped(Activity activity) { }
            @Override public void onActivityPostStopped(Activity activity) { }
            @Override public void onActivitySaveInstanceState(Activity activity, Bundle outState) { }
            @Override public void onActivityDestroyed(Activity activity) { }
        });
    }

    private static void apply(Activity activity) {
        View root = activity.findViewById(android.R.id.content);
        if (root != null) SpanishUi.apply(root);
    }
}
