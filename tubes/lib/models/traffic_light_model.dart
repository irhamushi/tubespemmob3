class TrafficLight {
  final int id;
  final int junctionId;
  final String? direction;
  final double lat;
  final double lng;
  final String status;

  TrafficLight({
    required this.id,
    required this.junctionId,
    this.direction,
    required this.lat,
    required this.lng,
    required this.status,
  });

  factory TrafficLight.fromJson(Map<String, dynamic> json) {
    return TrafficLight(
      id: int.tryParse(json['id'].toString()) ?? 0,
      junctionId: int.tryParse(json['junction_id'].toString()) ?? 0,
      direction: json['direction']?.toString(),
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lng: double.tryParse(json['lng'].toString()) ?? 0.0,
      status: json['status']?.toString() ?? 'RED',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'junction_id': junctionId,
    'direction': direction,
    'lat': lat,
    'lng': lng,
    'status': status,
  };
}
