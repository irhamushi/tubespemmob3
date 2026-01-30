import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/traffic_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List lights = [];
  Timer? refreshTimer;
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    loadLights();
    startAutoRefresh(); // ⬅️ REALTIME ENGINE
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  // 🔁 AUTO REFRESH SYSTEM
  void startAutoRefresh() {
    refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      loadLights();
    });
  }

  Future<void> loadLights() async {
    try {
      final data = await TrafficService.getLights();
      if (mounted) {
        setState(() {
          lights = data;
        });
      }
    } catch (e) {
      print("ERROR LOAD LIGHTS: $e");
    }
  }

  Color getColor(String status) {
    if (status == "GREEN") return Colors.green;
    if (status == "YELLOW") return Colors.yellow;
    return Colors.red;
  }

  IconData getIcon(String status) {
    if (status == "GREEN") return Icons.circle;
    if (status == "YELLOW") return Icons.circle;
    return Icons.circle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Traffic System")),

      // 🔥 BUTTON EDIT MODE
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            editMode = !editMode;
          });
        },
        child: Icon(editMode ? Icons.edit_off : Icons.edit),
      ),

      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-6.9900, 110.4229),
          initialZoom: 14,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.traffic_app',
          ),

          // 🚦 REALTIME MARKER
          MarkerLayer(
            markers: lights.map((l) {
              return Marker(
                point: LatLng(
                  double.parse(l['lat'].toString()),
                  double.parse(l['lng'].toString()),
                ),
                width: 35,
                height: 35,
                child: GestureDetector(
                  onTap: () {
                    if (!editMode)
                      return; // ❌ kalau editMode false → ga bisa klik
                    print("EDIT MODE TAP: ${l['id']}");
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.traffic,
                        color: getColor(l['status']),
                        size: 28,
                      ),
                      Text(
                        l['status'],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
