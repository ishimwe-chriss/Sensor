package com.example.sensormobileapplication

//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val SENSOR_STREAM = "com.example.light_sensor/ambient_light"
    private lateinit var sensorManager: SensorManager
    private lateinit var lightSensor: Sensor
    private var lightSensorListener: SensorEventListener? = null

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SENSOR_STREAM).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
                    lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT) ?: return
                    lightSensorListener = object : SensorEventListener {
                        override fun onSensorChanged(event: SensorEvent) {
                            events?.success(event.values[0])
                        }

                        override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {}
                    }
                    sensorManager.registerListener(
                        lightSensorListener,
                        lightSensor,
                        SensorManager.SENSOR_DELAY_NORMAL
                    )
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager.unregisterListener(lightSensorListener)
                }
            }
        )
    }
}
