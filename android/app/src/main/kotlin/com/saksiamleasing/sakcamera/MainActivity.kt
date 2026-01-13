package com.saksiamleasing.sakcamera

import android.content.Intent
import android.provider.Settings
import android.media.MediaScannerConnection

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// class MainActivity : FlutterActivity()
class MainActivity : FlutterActivity() {

    private val CHANNEL = "app.channel.shared.data"
    private val CHANNEL_MEDIA_SCAN = "com.sakcamera.media_scan"

    // override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    //     super.onActivityResult(requestCode, resultCode, data)
    // }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // เปิดหน้า Date Settings
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openDateSettings") {
                    val intent = Intent(Settings.ACTION_DATE_SETTINGS)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                    result.success(true)
                } else {
                    result.notImplemented()
                }
            }

        // Media Scanner สำหรับ Android 9
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_MEDIA_SCAN)
            .setMethodCallHandler { call, result ->
                if (call.method == "scanFile") {
                    val path = call.argument<String>("path")
                    if (path != null) {
                        MediaScannerConnection.scanFile(
                            applicationContext,
                            arrayOf(path),
                            null,
                            null
                        )
                        result.success(true)
                    } else {
                        result.error("INVALID_PATH", "Path is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    // share file
    // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine)
    //     {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine);
    //         MethodChannel (flutterEngine.getDartExecutor().getBinaryMessenger(), "sakerp.share/share")
    //     .setMethodCallHandler{ methodCall, result ->
    //         if (methodCall.method == "shareFile") {
    //             shareFile(methodCall.arguments as String)
    //         }
    //     }
    //     }
    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)
    //     GeneratedPluginRegistrant.registerWith(this)
    //     MethodChannel(flutterView, "sakerp.share/share").setMethodCallHandler{
    //         methodCall, result ->
    //         if(methodCall.method == "shareFile"){
    //             shareFile(methodCall.arguments as String)
    //         }
    //     }
    // }
    // private fun shareFile(path: String) {
    //     val imageFile = File(cacheDir, path)
    //     val contentUri = FileProvider.getUriForFile(this, "com.saksiamleasing.sakerp", imageFile)
    //     Intent(Intent.ACTION_SEND).let {
    //         it.type = "image/png"
    //         it.putExtra(Intent.EXTRA_STREAM, contentUri)
    //         startActivity(Intent.createChooser(it, "Share QRCode"))
    //         Toast.makeText(applicationContext, "SAKERP", Toast.LENGTH_LONG).show()
    //     }
    // }
    // share file
    // package (flutter_inappwebview)
    // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine)
    // }
    // package (flutter_inappwebview)
    // kotlin version >= 35
    // companion object {
    //     private const val REQUEST_OVERLAY_PERMISSIONS = 100
    // }
    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)
    //     verify drawing permissions and display overlays.
    //     checkOverlayPermission()
    // }
    // private fun checkOverlayPermission() {
    //     if (!Settings.canDrawOverlays(applicationContext)) {
    //         if not, open the rights management screen.
    //         val myIntent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
    //         val uri: Uri = Uri.fromParts("package", packageName, null)
    //         myIntent.data = uri
    //         startActivityForResult(myIntent, REQUEST_OVERLAY_PERMISSIONS)
    //     }
    // }
    // kotlin version >= 35
}