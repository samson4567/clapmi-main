package com.clapmi.mvp

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.Intent
import android.graphics.Rect
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.util.Log
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.clapmi.mvp/screen_capture"
    private val REQUEST_MEDIA_PROJECTION = 1001
    private val REQUEST_MEDIA_PROJECTION_SINGLE_APP = 1002

    private var pendingResult: MethodChannel.Result? = null
    private var mediaProjectionManager: MediaProjectionManager? = null
    private var isSingleAppCapture = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        mediaProjectionManager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startScreenCapture" -> {
                    Log.d("MainActivity", "🔍 startScreenCapture called with mode: ${call.argument<String>("mode")}");
                    val captureMode = call.argument<String>("mode") ?: "full_screen"
                    isSingleAppCapture = captureMode == "single_app"
                    pendingResult = result
                    Log.d("MainActivity", "🔍 Requesting screen capture permission (singleApp=$isSingleAppCapture)");
                    requestScreenCapturePermission(isSingleAppCapture)
                }
                "stopScreenCapture" -> {
                    ScreenCaptureService.stopService(this)
                    result.success(true)
                }
                "isServiceRunning" -> {
                    result.success(ScreenCaptureService.isServiceRunning())
                }
                "enterPictureInPicture" -> {
                    val width = call.argument<Int>("width") ?: 9
                    val height = call.argument<Int>("height") ?: 16
                    result.success(enterPictureInPicture(width, height))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun enterPictureInPicture(width: Int, height: Int): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            Log.w("MainActivity", "Picture-in-Picture requires Android 8.0+")
            return false
        }

        return try {
            val safeWidth = width.coerceAtLeast(1)
            val safeHeight = height.coerceAtLeast(1)
            val builder = PictureInPictureParams.Builder()
                .setAspectRatio(Rational(safeWidth, safeHeight))

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val decorView = window.decorView
                if (decorView.width > 0 && decorView.height > 0) {
                    builder.setSourceRectHint(
                        Rect(
                            decorView.left,
                            decorView.top,
                            decorView.right,
                            decorView.bottom
                        )
                    )
                }
            }

            enterPictureInPictureMode(builder.build())
            true
        } catch (error: Exception) {
            Log.e("MainActivity", "Failed to enter Picture-in-Picture", error)
            false
        }
    }

    private fun requestScreenCapturePermission(singleApp: Boolean) {
        val requestCode = if (singleApp) REQUEST_MEDIA_PROJECTION_SINGLE_APP else REQUEST_MEDIA_PROJECTION
        
        val captureIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE && singleApp) {
            // Android 14+ single-app capture
            Log.d("MainActivity", "Requesting SINGLE-APP screen capture (Android 14+)")
            if (Build.VERSION.SDK_INT >= 34) {
                mediaProjectionManager?.createScreenCaptureIntent(
                    android.media.projection.MediaProjectionConfig.createConfigForDefaultDisplay()
                )
            } else {
                mediaProjectionManager?.createScreenCaptureIntent()
            }
        } else {
            // Full-screen capture (all versions)
            Log.d("MainActivity", "Requesting FULL-SCREEN capture")
            mediaProjectionManager?.createScreenCaptureIntent()
        }
        startActivityForResult(captureIntent, requestCode)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_MEDIA_PROJECTION || requestCode == REQUEST_MEDIA_PROJECTION_SINGLE_APP) {
            val isSingleApp = requestCode == REQUEST_MEDIA_PROJECTION_SINGLE_APP
            
            if (resultCode == Activity.RESULT_OK && data != null) {
                Log.d("MainActivity", "MediaProjection permission granted")
                Log.d("MainActivity", "Capture mode: ${if (isSingleApp) "SINGLE-APP" else "FULL-SCREEN"}")
                
                // IMPORTANT: For single-app capture, warn user
                if (isSingleApp) {
                    Log.w("MainActivity", "⚠️ SINGLE-APP CAPTURE: The captured app MUST remain visible/foreground!")
                    Log.w("MainActivity", "⚠️ If the app is minimized or covered, screen will be BLACK")
                }

                // Store the permission data
                ScreenCaptureService.setMediaProjectionData(resultCode, data)
                ScreenCaptureService.setSingleAppMode(isSingleApp)

                // Start the service
                val success = ScreenCaptureService.startService(this)
                
                if (success) {
                    Log.d("MainActivity", "✓ ScreenCaptureService started successfully")
                } else {
                    Log.e("MainActivity", "✗ Failed to start ScreenCaptureService")
                }
                
                pendingResult?.success(success)
            } else {
                Log.e("MainActivity", "MediaProjection permission denied")
                pendingResult?.error("PERMISSION_DENIED", "Screen capture permission denied", null)
            }
            pendingResult = null
        }
    }
}
