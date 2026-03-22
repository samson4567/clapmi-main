package com.clapmi.mvp

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import android.util.DisplayMetrics
import android.util.Log
import android.view.WindowManager
import androidx.core.app.NotificationCompat

class ScreenCaptureService : Service() {
    
    companion object {
        private const val CHANNEL_ID = "screen_capture_channel"
        private const val NOTIFICATION_ID = 2001
        private const val TAG = "ScreenCaptureService"
        
        const val ACTION_START = "ACTION_START"
        const val ACTION_STOP = "ACTION_STOP"
        
        // Store the permission data here temporarily
        private var capturePermissionResultCode: Int = 0
        private var capturePermissionData: Intent? = null
        private var isSingleAppMode = false
        
        // Virtual Display metrics
        private var virtualDisplayWidth: Int = 1920
        private var virtualDisplayHeight: Int = 1080
        private var virtualDisplayDensity: Int = 320
        
        @Volatile
        private var isRunning = false
        
        // Callback for screen capture data
        var onScreenCaptureCallback: ((ByteArray?) -> Unit)? = null
        
        fun isServiceRunning(): Boolean = isRunning
        
        // Store the permission data before starting service
        fun setMediaProjectionData(resultCode: Int, data: Intent) {
            capturePermissionResultCode = resultCode
            capturePermissionData = data
            Log.d(TAG, "MediaProjection data stored: resultCode=$resultCode")
        }
        
        fun setSingleAppMode(singleApp: Boolean){
            isSingleAppMode = singleApp
            Log.d(TAG, "Single-app mode set to: $singleApp")
        }

        fun isSingleAppCapture(): Boolean = isSingleAppMode

        // Check if battery optimization is disabled for this app
        fun isBatteryOptimizationDisabled(context: Context): Boolean {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            return powerManager.isIgnoringBatteryOptimizations(context.packageName)
        }

        // Request battery optimization exemption
        fun requestBatteryOptimizationExemption(context: Context): Boolean {
            return try {
                val manufacturer = Build.MANUFACTURER.lowercase()
                val isSamsung = manufacturer.contains("samsung")
                
                if (!isBatteryOptimizationDisabled(context)) {
                    Log.w(TAG, "⚠️ Battery optimization is ENABLED - requesting exemption")
                    if (isSamsung) {
                        Log.w(TAG, "⚠️ SAMSUNG: Please disable battery optimization manually:")
                        Log.w(TAG, "⚠️ Settings > Apps > Clapmi > Battery > Unrestricted")
                    }
                    // Open battery optimization settings
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                        data = Uri.parse("package:${context.packageName}")
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    context.startActivity(intent)
                    true
                } else {
                    Log.d(TAG, "✓ Battery optimization already disabled")
                    true
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error requesting battery exemption: ${e.message}")
                false
            }
        }

        @Synchronized
        fun startService(context: Context): Boolean {
            if (isRunning) {
                Log.d(TAG, "Service already running")
                return true
            }
            
            if (capturePermissionData == null) {
                Log.e(TAG, "Cannot start service: MediaProjection permission not set")
                return false
            }
            
            val intent = Intent(context, ScreenCaptureService::class.java).apply {
                action = ACTION_START
            }
            
            return try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
                Log.d(TAG, "Service start requested successfully")
                true
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start service: ${e.message}", e)
                false
            }
        }
        
        @Synchronized
        fun stopService(context: Context) {
            if (!isRunning) {
                Log.d(TAG, "Service not running, nothing to stop")
                return
            }
            
            val intent = Intent(context, ScreenCaptureService::class.java).apply {
                action = ACTION_STOP
            }
            context.startService(intent)
            Log.d(TAG, "Service stop requested")
        }
    }
    
    private var notificationManager: NotificationManager? = null
    private var mediaProjection: MediaProjection? = null
    private var mediaProjectionManager: MediaProjectionManager? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var windowManager: WindowManager? = null
    
    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service created")
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        mediaProjectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        createNotificationChannel()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "onStartCommand called with action: ${intent?.action}")
        
        when (intent?.action) {
            ACTION_START -> {
                if (!isRunning) {
                    if (capturePermissionResultCode != 0 && capturePermissionData != null) {
                        startForegroundService(capturePermissionResultCode, capturePermissionData!!)
                    } else {
                        Log.e(TAG, "Missing MediaProjection permission data!")
                        stopSelf()
                    }
                }
            }
            ACTION_STOP -> {
                stopForegroundService()
            }
            else -> {
                Log.w(TAG, "Unknown action, stopping service")
                stopSelf()
            }
        }
        
        // Samsung devices: Use START_STICKY to help service restart if killed
        val manufacturer = Build.MANUFACTURER.lowercase()
        val isSamsung = manufacturer.contains("samsung")
        
        return if (isSamsung) {
            Log.d(TAG, "SAMSUNG: Using START_STICKY for better reliability")
            START_STICKY
        } else {
            START_NOT_STICKY
        }
    }
    
    // Samsung-specific: Override onTaskRemoved to restart service if needed
    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        
        val manufacturer = Build.MANUFACTURER.lowercase()
        val isSamsung = manufacturer.contains("samsung")
        
        if (isSamsung && isRunning) {
            Log.w(TAG, "⚠️ SAMSUNG: Task removed but service running - attempting to restart")
            // On Samsung, we want to try to restart the service
            // Note: This may not work if the user force-closed the app
        }
    }
    
    private fun getScreenMetrics(): Triple<Int, Int, Int> {
        val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val metrics = DisplayMetrics()
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val windowMetrics = windowManager.maximumWindowMetrics
            val bounds = windowMetrics.bounds
            virtualDisplayWidth = bounds.width()
            virtualDisplayHeight = bounds.height()
        } else {
            @Suppress("DEPRECATION")
            val display = windowManager.defaultDisplay
            display.getRealMetrics(metrics)
            virtualDisplayWidth = metrics.widthPixels
            virtualDisplayHeight = metrics.heightPixels
        }
        
        virtualDisplayDensity = resources.displayMetrics.densityDpi
        
        Log.d(TAG, "Screen metrics: ${virtualDisplayWidth}x${virtualDisplayHeight} @ $virtualDisplayDensity dpi")
        
        return Triple(virtualDisplayWidth, virtualDisplayHeight, virtualDisplayDensity)
    }
    
    private fun startForegroundService(resultCode: Int, data: Intent) {
        try {
            Log.d(TAG, "Starting foreground service with MediaProjection permission")
            Log.d(TAG, "Single-app mode: $isSingleAppMode")
            
            // Detect Samsung device for Samsung-specific handling
            val manufacturer = Build.MANUFACTURER.lowercase()
            val isSamsung = manufacturer.contains("samsung")
            Log.d(TAG, "📱 Device: $manufacturer (isSamsung: $isSamsung)")
            
            // Samsung-specific: Check for battery optimization
            if (isSamsung) {
                Log.w(TAG, "⚠️ SAMSUNG DEVICE DETECTED - may need battery optimization disabled")
                Log.w(TAG, "⚠️ User should: Settings > Apps > Clapmi > Battery > Unrestricted")
                
                // Try to request battery optimization exemption
                requestBatteryOptimizationExemption(this)
            }
            
            // Get screen metrics
            val (width, height, density) = getScreenMetrics()
            virtualDisplayWidth = width
            virtualDisplayHeight = height
            virtualDisplayDensity = density
            
            val notification = createNotification("Preparing screen share...")
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
            
            Log.d(TAG, "Foreground service started, getting MediaProjection")
            
            mediaProjection = mediaProjectionManager?.getMediaProjection(resultCode, data)
            
            if (mediaProjection == null) {
                Log.e(TAG, "Failed to get MediaProjection")
                stopSelf()
                return
            }
            
            Log.d(TAG, "✓ MediaProjection obtained successfully")
            isRunning = true
            
            // Create VirtualDisplay for screen capture
            createVirtualDisplay()
            
            // Register callback with visibility tracking
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                mediaProjection?.registerCallback(object : MediaProjection.Callback() {
                    override fun onStop() {
                        Log.w(TAG, "⚠️ MediaProjection onStop called - NOT stopping service automatically!")
                        // Don't stop the service automatically - let Flutter handle it
                        // This prevents premature stopping when user closes the selection dialog
                    }
                    
                    override fun onCapturedContentVisibilityChanged(isVisible: Boolean) {
                        super.onCapturedContentVisibilityChanged(isVisible)
                        if (isSingleAppMode) {
                            if (isVisible) {
                                Log.d(TAG, "✓ Captured app is VISIBLE - screen capture working")
                            } else {
                                Log.w(TAG, "⚠️ Captured app is NOT VISIBLE - screen will be BLACK!")
                                Log.w(TAG, "⚠️ Bring the captured app to foreground to resume capture")
                            }
                        }
                    }
                    
                    override fun onCapturedContentResize(width: Int, height: Int) {
                        super.onCapturedContentResize(width, height)
                        Log.d(TAG, "Captured content resized: ${width}x${height}")
                    }
                }, null)
            } else {
                mediaProjection?.registerCallback(object : MediaProjection.Callback() {
                    override fun onStop() {
                        Log.w(TAG, "⚠️ MediaProjection onStop called - NOT stopping service automatically!")
                        // Don't stop automatically - let Flutter handle it
                    }
                }, null)
            }
            
            // Update notification
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    val message = if (isSingleAppMode) {
                        "Screen sharing active (single-app)"
                    } else {
                        "Screen sharing active (full-screen)"
                    }
                    val activeNotification = createNotification(message)
                    notificationManager?.notify(NOTIFICATION_ID, activeNotification)
                    Log.d(TAG, "Notification updated: $message")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to update notification: ${e.message}")
                }
            }, 500)
            
            Log.d(TAG, "✅ Screen capture service fully initialized")
            
        } catch (e: SecurityException) {
            Log.e(TAG, "SecurityException: ${e.message}", e)
            isRunning = false
            stopSelf()
        } catch (e: Exception) {
            Log.e(TAG, "Error starting foreground service: ${e.message}", e)
            isRunning = false
            stopSelf()
        }
    }
    
    private fun createVirtualDisplay() {
        if (mediaProjection == null) {
            Log.e(TAG, "Cannot create VirtualDisplay: MediaProjection is null")
            return
        }
        
        try {
            // Use 720p as default for performance, can be adjusted
            val width = 1280
            val height = 720
            val density = virtualDisplayDensity
            
            // Get device info for debugging Samsung-specific issues
            val manufacturer = Build.MANUFACTURER.lowercase()
            val isSamsung = manufacturer.contains("samsung")
            Log.d(TAG, "Device Manufacturer: $manufacturer (Samsung: $isSamsung)")
            
            // Samsung devices may need explicit surface configuration
            // Try with VIRTUAL_DISPLAY_FLAG_OWN_CONTENT_ONLY for Samsung
            val displayFlags = if (isSamsung) {
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR or DisplayManager.VIRTUAL_DISPLAY_FLAG_OWN_CONTENT_ONLY
            } else {
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR
            }
            
            Log.d(TAG, "Creating VirtualDisplay with flags: $displayFlags")
            
            virtualDisplay = mediaProjection?.createVirtualDisplay(
                "ScreenCapture",
                width,
                height,
                density,
                displayFlags,
                null, // No surface, we just need the projection active
                null,
                null
            )
            
            if (virtualDisplay != null) {
                Log.d(TAG, "✅ VirtualDisplay created successfully at ${width}x${height}")
            } else {
                Log.e(TAG, "❌ Failed to create VirtualDisplay")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error creating VirtualDisplay: ${e.message}", e)
        }
    }
    
    private fun releaseVirtualDisplay() {
        try {
            virtualDisplay?.release()
            virtualDisplay = null
            Log.d(TAG, "VirtualDisplay released")
        } catch (e: Exception) {
            Log.e(TAG, "Error releasing VirtualDisplay: ${e.message}")
        }
    }
    
    private fun stopForegroundService() {
        try {
            Log.d(TAG, "Stopping foreground service")
            
            // Release virtual display
            releaseVirtualDisplay()
            
            // Stop media projection
            mediaProjection?.stop()
            mediaProjection = null
            
            isRunning = false
            
            // Clear the stored permission data
            capturePermissionResultCode = 0
            capturePermissionData = null
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } else {
                @Suppress("DEPRECATION")
                stopForeground(true)
            }
            
            stopSelf()
            Log.d(TAG, "Foreground service stopped successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping service: ${e.message}", e)
        }
    }
    
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
    
    override fun onDestroy() {
        super.onDestroy()
        releaseVirtualDisplay()
        mediaProjection?.stop()
        mediaProjection = null
        isRunning = false
        Log.d(TAG, "Service destroyed")
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Detect Samsung for special notification handling
            val manufacturer = Build.MANUFACTURER.lowercase()
            val isSamsung = manufacturer.contains("samsung")
            
            // Samsung devices need higher importance for reliable foreground service
            val importance = if (isSamsung) {
                NotificationManager.IMPORTANCE_HIGH
            } else {
                NotificationManager.IMPORTANCE_LOW
            }
            
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Screen Capture Service",
                importance
            ).apply {
                description = "Screen sharing is active"
                setShowBadge(true)
                setSound(null, null)
                enableLights(true)
                // Samsung-specific: Reduce vibration to save battery but keep visible
                enableVibration(if (isSamsung) false else false)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            
            notificationManager?.createNotificationChannel(channel)
            Log.d(TAG, "Notification channel created (Samsung: $isSamsung, importance: $importance)")
        }
    }
    
    private fun createNotification(text: String): Notification {
        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            } else {
                PendingIntent.FLAG_UPDATE_CURRENT
            }
        )
        
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Clapmi")
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_camera)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(true)
            .setContentIntent(pendingIntent)
            .setSound(null)
            .setVibrate(null)
            .build()
    }
}
