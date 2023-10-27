package in.lazymanstudios.uri_to_file.model;

import android.content.ContentResolver;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.provider.OpenableColumns;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.Random;
import java.util.UUID;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.plugin.common.MethodChannel;

public class UriToFile {
    private static final String TAG = "UriToFile";
    private static final ExecutorService executorService = Executors.newFixedThreadPool(3);
    private final Context context;

    public UriToFile(Context context) {
        this.context = context;
    }

    public void fromUri(MethodChannel.Result result, String uriString) {
        try {
            if(uriString != null) {
                Uri uri = parseUri(uriString);
                if (uri != null) {
                    String scheme = uri.getScheme();
                    if (scheme != null && scheme.equals(ContentResolver.SCHEME_CONTENT)) {
                        String fileName = getFileName(uri);
                        copyFile(result, uri, fileName);
                    } else {
                        sendUnsupportedUriMessage(result);
                    }
                } else {
                    sendUnsupportedUriMessage(result);
                }
            } else {
                sendUnsupportedUriMessage(result);
            }
        } catch (Exception ex) {
            sendErrorMessage(result, ex.getMessage());
        }
    }

    public void clearTemporaryFiles(MethodChannel.Result result) {
        try {
            executorService.submit(new ClearCacheCallable(context, result));
        } catch (Exception ex) {
            sendErrorMessage(result, ex.getMessage());
        }
    }

    private Uri parseUri(String uriString) {
        try {
            return Uri.parse(uriString);
        } catch (Exception ex) {
            Log.e(TAG, "Failed to parse uri: " + ex.toString());
        }
        return null;
    }

    private String getFileName(Uri uri) {
        String filename = null;

        try {
            Cursor cursor = context.getContentResolver().query(uri, new String[]{OpenableColumns.DISPLAY_NAME}, null, null, null);
            try {
                if (cursor != null && cursor.moveToFirst()) {
                    int index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
                    if (index != -1) {
                        filename = cursor.getString(index);
                    }
                }
            } finally {
                if (cursor != null) {
                    cursor.close();
                }
            }

            if(filename == null || filename.isEmpty()) {
                filename = uri.getLastPathSegment();
            }
        } catch (Exception ex) {
            Log.e(TAG, "Failed to get file name: " + ex.toString());
        }

        if (filename == null || filename.isEmpty()) {
            filename = "" + new Random().nextInt(100000);
        }

        return filename;
    }

    private void copyFile(MethodChannel.Result result, Uri uri, String name) {
        executorService.submit(new CopyFileCallable(context, result, uri, name));
    }

    private void sendUnsupportedUriMessage(MethodChannel.Result result) {
        result.error("URI_NOT_SUPPORTED", "Uri not supported", null);
    }

    private void sendErrorMessage(MethodChannel.Result result, String message) {
        result.error("IO_EXCEPTION", message, null);
    }

    private static class CopyFileCallable implements Callable<Boolean> {
        private final Context context;
        private final MethodChannel.Result result;
        private final Uri uri;
        private final String name;

        public CopyFileCallable(Context context, MethodChannel.Result result, Uri uri, String name) {
            this.context = context;
            this.result = result;
            this.uri = uri;
            this.name = name;
        }

        private static synchronized File getCacheDirectory(Context context) throws IOException {
            File cacheDirectory = context.getCacheDir();

            String fileDirectory = UUID.randomUUID().toString();
            File outputDirectory = new File(cacheDirectory + File.separator + "uri_to_file" + File.separator + fileDirectory);

            while (outputDirectory.exists()) {
                fileDirectory = UUID.randomUUID().toString();
                outputDirectory = new File(cacheDirectory+ File.separator + "uri_to_file" + File.separator + fileDirectory);
            }

            boolean isOutputDirectoryCreated = outputDirectory.mkdirs();

            if (isOutputDirectoryCreated) {
                return outputDirectory;
            } else {
                throw new IOException("Failed to create output directory");
            }
        }

        private void copyUriToFile(Uri uri, File outputFile) throws IOException {
            AssetFileDescriptor assetFileDescriptor = null;
            FileChannel inputChannel = null;
            FileChannel outputChannel = null;

            try {
                assetFileDescriptor = context.getContentResolver().openAssetFileDescriptor(uri, "r");
                inputChannel = new FileInputStream(assetFileDescriptor.getFileDescriptor()).getChannel();

                outputChannel = new FileOutputStream(outputFile).getChannel();

                long bytesTransferred = 0;
                while (bytesTransferred < inputChannel.size()) {
                    bytesTransferred += outputChannel.transferFrom(inputChannel, bytesTransferred, inputChannel.size());
                }

                if (!outputFile.exists()) {
                    throw new IOException("Failed to copy uri content to file");
                }
            } finally {
                try {
                    if (assetFileDescriptor != null) {
                        assetFileDescriptor.close();
                    }
                    if (inputChannel != null) {
                        inputChannel.close();
                    }
                    if (outputChannel != null) {
                        outputChannel.close();
                    }
                } catch (Exception ex) {
                    Log.e(TAG, ex.getMessage());
                }
            }
        }

        @Override
        public Boolean call() {
            try {
                File cacheDirectory = getCacheDirectory(context);
                File outputFile = new File(cacheDirectory + File.separator + this.name);

                copyUriToFile(this.uri, outputFile);

                sendSuccessResult(outputFile.getAbsolutePath());
            } catch (Exception ex) {
                sendErrorResult(ex.getMessage());
            }
            return true;
        }

        private void sendSuccessResult(final String filepath) {
            result.success(filepath);
        }

        private void sendErrorResult(final String errorMessage) {
            result.error("IO_EXCEPTION", errorMessage, null);
        }
    }

    private static class ClearCacheCallable implements Callable<Boolean> {
        private final Context context;
        private final MethodChannel.Result result;

        public ClearCacheCallable(Context context, MethodChannel.Result result) {
            this.context = context;
            this.result = result;
        }

        private void delete(File file) {
            File[] subfiles = file.listFiles();

            if (subfiles != null) {
                for (File i : subfiles) {
                    if (i.isDirectory()) {
                        delete(i);
                    }
                    i.delete();
                }
            }
        }

        @Override
        public Boolean call() {
            try {
                File cacheDirectory = context.getCacheDir();
                File appCacheDirectory = new File(cacheDirectory + File.separator + "uri_to_file");
                delete(appCacheDirectory);

                sendSuccessResult();
            } catch (Exception ex) {
                sendErrorResult(ex.getMessage());
            }
            return true;
        }

        private void sendSuccessResult() {
            result.success(true);
        }

        private void sendErrorResult(final String errorMessage) {
            result.error("IO_EXCEPTION", errorMessage, null);
        }
    }
}
