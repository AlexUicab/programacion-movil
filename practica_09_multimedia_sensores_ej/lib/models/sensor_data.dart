class SensorData {
  final double x;
  final double y;
  final double z;

  const SensorData({this.x = 0, this.y = 0, this.z = 0});

  @override
  String toString() =>
      'X: ${x.toStringAsFixed(2)} | Y: ${y.toStringAsFixed(2)} | Z: ${z.toStringAsFixed(2)}';
}