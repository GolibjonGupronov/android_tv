package com.example.android_tv_my

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log

class BootReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "BootReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Boot event received: ${intent.action}")

        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            Handler(Looper.getMainLooper()).postDelayed({
                try {
                    val launchIntent = Intent(context, MainActivity::class.java).apply {
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    }
                    context.startActivity(launchIntent)
                    Log.d(TAG, "MainActivity launched successfully")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to launch MainActivity", e)
                }
            }, 3000)
        }
    }
}