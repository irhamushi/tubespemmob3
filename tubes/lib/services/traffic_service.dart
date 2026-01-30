import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/traffic_light_model.dart';

class TrafficService {
  static const String baseUrl = 'http://10.0.2.2/traffic_api';
  static const int timeoutSeconds = 10;

  static Future<List<TrafficLight>> getLights() async {
    final uri = Uri.parse('$baseUrl/get_lights.php');
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: timeoutSeconds));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Accept both raw list or wrapper { data: [...] }
      if (data is List) {
        return data.map<TrafficLight>((e) => TrafficLight.fromJson(e)).toList();
      } else if (data is Map && data['data'] is List) {
        return (data['data'] as List)
            .map<TrafficLight>((e) => TrafficLight.fromJson(e))
            .toList();
      }
      throw Exception('Unexpected response format from get_lights.php');
    } else {
      throw Exception('Server error ${response.statusCode}');
    }
  }

  static Future<TrafficLight> getLightById(int id) async {
    final uri = Uri.parse('$baseUrl/get_light.php?id=$id');
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: timeoutSeconds));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) return TrafficLight.fromJson(data);
      if (data is List && data.isNotEmpty)
        return TrafficLight.fromJson(data.first);
      throw Exception('Unexpected response format from get_light.php');
    } else {
      throw Exception('Server error ${response.statusCode}');
    }
  }

  static Future<bool> updateLightStatus(int id, String status) async {
    final uri = Uri.parse('$baseUrl/update_light.php');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'id': id, 'status': status}),
        )
        .timeout(const Duration(seconds: timeoutSeconds));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map && data.containsKey('success'))
        return data['success'] == true;
      if (data is Map && data.containsKey('error'))
        throw Exception('API error: ${data['error']}');
      return true; // assume ok if server returned 200 with no payload
    }
    throw Exception('Server error ${response.statusCode}');
  }

  static Future<bool> triggerLoopStep() async {
    final uri = Uri.parse('$baseUrl/loop_step.php');
    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: timeoutSeconds));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map && data.containsKey('success'))
        return data['success'] == true;
      return true;
    }
    throw Exception('Loop step failed: ${response.statusCode}');
  }
}
