package in.lazymanstudios.uri_to_file.model;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.MethodChannel;

public class MethodResultWrapper implements MethodChannel.Result {
    private final MethodChannel.Result globalResult;
    private final Handler handler;

    public MethodResultWrapper(MethodChannel.Result result) {
        this.globalResult = result;
        handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void success(@Nullable final Object result) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                globalResult.success(result);
            }
        });
    }

    @Override
    public void error(final String errorCode, @Nullable final String errorMessage, @Nullable final Object errorDetails) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                globalResult.error(errorCode, errorMessage, errorDetails);
            }
        });
    }

    @Override
    public void notImplemented() {
        handler.post(new Runnable() {
            @Override
            public void run() {
                globalResult.notImplemented();
            }
        });
    }
}
