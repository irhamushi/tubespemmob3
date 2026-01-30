import 'dart:async';
import 'package:flutter/material.dart';
import '../models/traffic_light_model.dart';
import '../services/traffic_service.dart';

class TrafficPage extends StatefulWidget {
  const TrafficPage({super.key});

  @override
  State<TrafficPage> createState() => _TrafficPageState();
}

class _TrafficPageState extends State<TrafficPage> {
  List<TrafficLight> lights = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _load();
    timer = Timer.periodic(const Duration(seconds: 3), (_) => _load());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final d = await TrafficService.getLights();
      if (mounted) setState(() => lights = d);
    } catch (e) {
      debugPrint('Traffic load error: $e');
    }
  }

  String buildReport(TrafficLight l) {
    if (l.status == 'RED') {
      return "🔴 Lampu merah, estimasi hijau ±10 detik";
    }
    if (l.status == 'YELLOW') {
      return "🟡 Transisi, siap berhenti";
    }
    return "🟢 Jalan lancar";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Traffic Report")),
      body: ListView.builder(
        itemCount: lights.length,
        itemBuilder: (ctx, i) {
          final l = lights[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: l.status == 'GREEN'
                    ? Colors.green
                    : (l.status == 'YELLOW' ? Colors.amber : Colors.red),
                child: const Icon(Icons.traffic, color: Colors.white),
              ),
              title: Text(
                l.direction ?? 'Area ${l.junctionId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(buildReport(l)),
            ),
          );
        },
      ),
    );
  }
}
