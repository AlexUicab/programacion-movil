import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/sensor_data.dart';

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  SensorData acelerometro = const SensorData();
  SensorData giroscopio = const SensorData();

  void start({
    required void Function() onUpdate,
    required void Function(Object) onError,
  }) {
    _accelSub?.cancel();
    _accelSub = accelerometerEventStream().listen(
      (e) {
        acelerometro = SensorData(x: e.x, y: e.y, z: e.z);
        onUpdate();
      },
      onError: onError,
    );

    _gyroSub?.cancel();
    _gyroSub = gyroscopeEventStream().listen(
      (e) {
        giroscopio = SensorData(x: e.x, y: e.y, z: e.z);
        onUpdate();
      },
      onError: onError,
    );
  }

  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _accelSub = null;
    _gyroSub = null;
  }
}