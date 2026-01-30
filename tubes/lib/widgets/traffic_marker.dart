import 'package:flutter/material.dart';
import '../models/traffic_light_model.dart';

class TrafficMarker extends StatelessWidget {
  final TrafficLight light;
  final void Function()? onTap;

  const TrafficMarker({super.key, required this.light, this.onTap});

  Color _colorForStatus(String status) {
    final s = status.toUpperCase();
    if (s == 'GREEN') return Colors.green;
    if (s == 'YELLOW') return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus(light.status);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: const Icon(Icons.traffic, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 4),
          Text(
            light.status,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
