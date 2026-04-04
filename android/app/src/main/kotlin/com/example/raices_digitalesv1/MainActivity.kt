package com.example.raices_digitalesv1

import android.app.Activity
import android.content.Intent
import android.media.RingtoneManager
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.raices_digitalesv1/ringtone_picker"
    private var pendingResult: MethodChannel.Result? = null
    private val RINGTONE_PICKER_REQUEST_CODE = 999

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "pickRingtone") {
                pendingResult = result
                val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER)
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_NOTIFICATION)
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "Seleccionar Sonido")
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
                intent.putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, true)

                val currentUriString = call.argument<String>("currentUri")
                if (currentUriString != null && currentUriString != "default" && currentUriString != "silent") {
                    intent.putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, Uri.parse(currentUriString))
                }

                startActivityForResult(intent, RINGTONE_PICKER_REQUEST_CODE)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RINGTONE_PICKER_REQUEST_CODE && pendingResult != null) {
            if (resultCode == Activity.RESULT_OK) {
                val uri = data?.getParcelableExtra<Uri>(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
                if (uri != null) {
                    val ringtone = RingtoneManager.getRingtone(this, uri)
                    val title = ringtone.getTitle(this)
                    val map = mutableMapOf<String, String>()
                    map["uri"] = uri.toString()
                    map["title"] = title
                    pendingResult?.success(map)
                } else {
                    // Silent selected
                    val map = mutableMapOf<String, String>()
                    map["uri"] = "silent"
                    map["title"] = "Silencio"
                    pendingResult?.success(map)
                }
            } else {
                // Cancelled
                pendingResult?.success(null)
            }
            pendingResult = null
        }
    }
}
