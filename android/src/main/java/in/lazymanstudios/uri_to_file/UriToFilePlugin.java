package in.lazymanstudios.uri_to_file;

import android.content.Context;

import androidx.annotation.NonNull;

import in.lazymanstudios.uri_to_file.helper.UriToFileMethodCallHandler;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/** UriToFilePlugin */
public class UriToFilePlugin implements FlutterPlugin {
  private static final String METHOD_CHANNEL = "in.lazymanstudios.uritofile/helper";

  private MethodChannel methodChannel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    setupMethodChannel(flutterPluginBinding.getApplicationContext(), flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    destoryMethodChannel();
  }

  void setupMethodChannel(Context context, BinaryMessenger binaryMessenger) {
    methodChannel = new MethodChannel(binaryMessenger, METHOD_CHANNEL);
    UriToFileMethodCallHandler methodCallHandler = new UriToFileMethodCallHandler(context);
    methodChannel.setMethodCallHandler(methodCallHandler);
  }

  void destoryMethodChannel() {
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
  }
}
