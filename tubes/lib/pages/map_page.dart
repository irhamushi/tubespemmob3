import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/traffic_light_model.dart';
import '../services/traffic_service.dart';
import '../widgets/traffic_marker.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<TrafficLight> lights = [];
  Timer? timer;
  bool loading = true;

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
      final data = await TrafficService.getLights();
      if (mounted) {
        setState(() {
          lights = data;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
      debugPrint('Error loading lights: $e');
    }
  }

  void _onMarkerTap(TrafficLight light) async {
    // show a small loading indicator while fetching detail
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final detail = await TrafficService.getLightById(light.id);
      if (!mounted) return;
      Navigator.pop(context); // remove loading dialog

      showModalBottomSheet(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.direction ?? 'Traffic Light #${detail.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Status: ${detail.status}'),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final ok = await TrafficService.updateLightStatus(
                          detail.id,
                          'GREEN',
                        );
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Status set to GREEN'),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Update failed: $e')),
                        );
                      }
                      Navigator.pop(context);
                      _load();
                    },
                    child: const Text('Set GREEN'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final ok = await TrafficService.updateLightStatus(
                          detail.id,
                          'RED',
                        );
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Status set to RED')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Update failed: $e')),
                        );
                      }
                      Navigator.pop(context);
                      _load();
                    },
                    child: const Text('Set RED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // ensure dialog removed if open
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load details: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(-6.9900, 110.4229),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smart_traffic_app',
              ),
              if (!loading && lights.isNotEmpty)
                MarkerLayer(
                  markers: lights.map((l) {
                    return Marker(
                      point: LatLng(l.lat, l.lng),
                      width: 60,
                      height: 80,
                      child: TrafficMarker(
                        light: l,
                        onTap: () => _onMarkerTap(l),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _load,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
