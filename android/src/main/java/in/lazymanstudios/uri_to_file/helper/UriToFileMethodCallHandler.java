package in.lazymanstudios.uri_to_file.helper;

import android.content.Context;

import androidx.annotation.NonNull;
import in.lazymanstudios.uri_to_file.model.MethodResultWrapper;
import in.lazymanstudios.uri_to_file.model.UriToFile;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class UriToFileMethodCallHandler implements MethodChannel.MethodCallHandler {
    private final UriToFile uriToFile;

    public UriToFileMethodCallHandler(Context context) {
        uriToFile = new UriToFile(context);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "fromUri": {
                String uriString = call.argument("uriString");
                uriToFile.fromUri(new MethodResultWrapper(result), uriString);
                break;
            }
            default: {
                result.notImplemented();
                break;
            }
        }
    }
}
