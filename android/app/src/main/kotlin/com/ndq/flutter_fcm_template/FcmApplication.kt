package com.ndq.flutter_fcm_template

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.NotificationManager.*
import android.content.Context
import android.os.Build
import io.flutter.app.FlutterApplication

class FcmApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        createDefaultNotificationChannel()
    }

    /**
     *  Create the NotificationChannel, but only on API 26+ because
     * the NotificationChannel class is new and not in the support library
     */
    private fun createDefaultNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelID = getString(R.string.notification_channel_id)
            val name = getString(R.string.notification_channel_name)
            val descriptionText = getString(R.string.notification_channel_desc)
            val importance = IMPORTANCE_HIGH
            val channel = NotificationChannel(channelID, name, importance).apply {
                description = descriptionText
            }
            // Register the channel with the system
            val notificationManager: NotificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

}