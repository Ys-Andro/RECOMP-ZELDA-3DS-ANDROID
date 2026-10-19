package org.triaevum.android;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.ViewGroup;

/** Pure Android SurfaceView providing the native Vulkan swapchain surface. */
final class TriAevumSurface extends SurfaceView implements SurfaceHolder.Callback {
    private static final double TARGET_ASPECT = 18.0 / 9.0;
    private int maximumShortEdge;

    TriAevumSurface(Context context, int maximumShortEdge) {
        super(context);
        this.maximumShortEdge = maximumShortEdge;
        setBackgroundColor(Color.BLACK);
        setLayoutParams(new ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        getHolder().addCallback(this);
    }

    public void updateSurfaceResolution(int maximumShortEdge) {
        if (this.maximumShortEdge == maximumShortEdge) return;
        this.maximumShortEdge = maximumShortEdge;
        applySurfaceExtent(getWidth(), getHeight());
    }

    @Override
    protected void onSizeChanged(int width, int height, int oldWidth, int oldHeight) {
        super.onSizeChanged(width, height, oldWidth, oldHeight);
        applySurfaceExtent(width, height);
    }

    private void applySurfaceExtent(int width, int height) {
        if (width <= 0 || height <= 0) return;
        int[] extent = fit18x9(width, height, maximumShortEdge);
        Log.i("TriAevum", "18:9 surface extent " + extent[0] + "x" + extent[1]
            + " inside view " + width + "x" + height
            + " (maxShortEdge=" + maximumShortEdge + ")");
        getHolder().setFixedSize(extent[0], extent[1]);
    }

    /**
     * Fits the largest 18:9 output inside the physical view and then applies the
     * configured short-edge budget. The view itself remains full-screen and black,
     * so any unused display area is never filled with a stretched game frame.
     */
    private static int[] fit18x9(int width, int height, int maximumShortEdge) {
        width = Math.max(1, width);
        height = Math.max(1, height);

        double viewAspect = (double) width / (double) height;
        int viewportWidth;
        int viewportHeight;
        if (viewAspect > TARGET_ASPECT) {
            viewportHeight = height;
            viewportWidth = Math.max(1, (int) Math.round(height * TARGET_ASPECT));
        } else {
            viewportWidth = width;
            viewportHeight = Math.max(1, (int) Math.round(width / TARGET_ASPECT));
        }

        if (maximumShortEdge > 0) {
            int shortEdge = Math.min(viewportWidth, viewportHeight);
            if (shortEdge > maximumShortEdge) {
                double scale = (double) maximumShortEdge / (double) shortEdge;
                viewportWidth = Math.max(1, (int) Math.round(viewportWidth * scale));
                viewportHeight = Math.max(1, (int) Math.round(viewportHeight * scale));
            }
        }
        return new int[] { viewportWidth, viewportHeight };
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
        Surface surface = holder.getSurface();
        Log.i("TriAevum", "surfaceCreated: " + surface);
        TriAevumActivity.nativeSurfaceCreated(surface);
        if (getContext() instanceof TriAevumActivity) {
            ((TriAevumActivity) getContext()).onSurfaceReady();
        }
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        int viewWidth = getWidth() > 0 ? getWidth() : width;
        int viewHeight = getHeight() > 0 ? getHeight() : height;
        int[] extent = fit18x9(viewWidth, viewHeight, maximumShortEdge);
        if (width != extent[0] || height != extent[1]) {
            holder.setFixedSize(extent[0], extent[1]);
            return;
        }
        Log.i("TriAevum", "18:9 render surface " + width + "x" + height
            + ", view " + viewWidth + "x" + viewHeight);
        TriAevumActivity.nativeSurfaceChanged(holder.getSurface(), width, height);
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        Log.i("TriAevum", "surfaceDestroyed");
        TriAevumActivity.nativeSurfaceDestroyed();
    }
}
