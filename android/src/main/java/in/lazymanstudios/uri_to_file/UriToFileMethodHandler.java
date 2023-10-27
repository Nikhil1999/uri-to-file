package in.lazymanstudios.uri_to_file;

import android.content.Context;

import androidx.annotation.NonNull;
import in.lazymanstudios.uri_to_file.model.MethodResultWrapper;
import in.lazymanstudios.uri_to_file.model.UriToFile;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UriToFileMethodHandler implements MethodChannel.MethodCallHandler {
    private final UriToFile model;

    public UriToFileMethodHandler(Context context) {
        model = new UriToFile(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "fromUri": {
                String uriString = call.argument("uriString");
                model.fromUri(new MethodResultWrapper(result), uriString);
                break;
            }
            case "clearTemporaryFiles": {
                model.clearTemporaryFiles(new MethodResultWrapper(result));
                break;
            }
            default: {
                result.notImplemented();
                break;
            }
        }
    }
}
