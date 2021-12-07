package in.lazymanstudios.uri_to_file.model;

import android.content.ContentResolver;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.provider.OpenableColumns;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.nio.channels.FileChannel;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.plugin.common.MethodChannel;

public class UriToFile {
    private final ExecutorService executorService;
    private final Context context;

    public UriToFile(Context context) {
        this.context = context;
        executorService = Executors.newFixedThreadPool(3);
    }

    public void fromUri(MethodResultWrapper result, String uriString) {
        Uri uri = Uri.parse(uriString);
        if(uri != null) {
            String scheme = uri.getScheme();
            if(scheme != null && scheme.equals(ContentResolver.SCHEME_CONTENT)) {
                String fileName = getFileName(uri);
                if(fileName != null && !fileName.isEmpty()) {
                    String name = fileName.substring(0, fileName.lastIndexOf('.'));
                    String ext = fileName.substring(fileName.lastIndexOf('.'));
                    if(name != null && !name.isEmpty()) {
                        copyFile(result, uri, name, ext);
                    } else {
                        sendUnableToGetFileName(result);
                    }
                } else {
                    sendUnableToGetFileName(result);
                }
            } else {
                sendUnsupportedUriMessage(result);
            }
        } else {
            sendUnsupportedUriMessage(result);
        }
    }

    private String getFileName(Uri uri) {
        String filename = null;

        Cursor cursor = context.getContentResolver().query(uri, null, null, null, null);
        if (cursor != null && cursor.moveToFirst())
        {
            int index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
            if (index != -1) {
                filename = cursor.getString(index);
            }
        }

        if(filename == null) {
            filename = uri.getLastPathSegment();
        }

        if (cursor != null) {
            cursor.close();
        }
        return filename;
    }

    private void copyFile(MethodChannel.Result result, Uri uri, String name, String ext) {
        executorService.submit(new CopyFileCallable(context, result, uri, name, ext));
    }

    private void sendUnsupportedUriMessage(MethodChannel.Result result) {
        result.error("URI_NOT_SUPPORTED", "Uri not supported", null);
    }

    private void sendUnableToGetFileName(MethodChannel.Result result) {
        result.error("IO_EXCEPTION", "Unable to fetch filename", null);
    }

    private static class CopyFileCallable implements Callable<Boolean> {
        private final Context context;
        private final MethodChannel.Result result;
        private final Uri uri;
        private final String name, ext;

        CopyFileCallable(Context context, MethodChannel.Result result, Uri uri, String name, String ext) {
            this.context = context;
            this.result = result;
            this.uri = uri;
            this.name = name;
            this.ext = ext;
        }

        @Override
        public Boolean call() {
            try {
                AssetFileDescriptor assetFileDescriptor = context.getContentResolver().openAssetFileDescriptor(uri, "r");
                FileChannel inputChannel = new FileInputStream(assetFileDescriptor.getFileDescriptor()).getChannel();

                File parent = new File(context.getFilesDir() + File.separator + "uri_to_file");
                parent.mkdirs();

                File file = new File(context.getFilesDir() + File.separator + "uri_to_file" + File.separator + name + ext);
                file.deleteOnExit();

                FileChannel outputChannel = new FileOutputStream(file).getChannel();

                long bytesTransferred = 0;
                while (bytesTransferred < inputChannel.size()) {
                    bytesTransferred += outputChannel.transferFrom(inputChannel, bytesTransferred, inputChannel.size());
                }

                final String filepath = file.getCanonicalPath();
                if(filepath != null && !filepath.isEmpty()) {
                    sendSuccessResult(filepath);
                } else {
                    sendErrorResult("IO_EXCEPTION", "Unable to fetch filepath");
                }
            } catch (final Exception e) {
                e.printStackTrace();
                sendErrorResult("IO_EXCEPTION", e.getMessage());
            }
            return true;
        }

        private void sendSuccessResult(final String filepath) {
            result.success(filepath);
        }

        private void sendErrorResult(final String errorCode, final String errorMessage) {
            result.error(errorCode, errorMessage, null);
        }
    }
}
