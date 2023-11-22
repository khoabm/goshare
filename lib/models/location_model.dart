import 'dart:convert';

class LocationModel {
  final String id;
  final String userId;
  final String address;
  final double latitude;
  final double longitude;
  final String name;
  final int type;
  LocationModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.type,
  });

  LocationModel copyWith({
    String? id,
    String? userId,
    String? address,
    double? latitude,
    double? longitude,
    String? name,
    int? type,
  }) {
    return LocationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'type': type,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
      type: map['type']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationModel(id: $id, userId: $userId, address: $address, latitude: $latitude, longitude: $longitude, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationModel &&
        other.id == id &&
        other.userId == userId &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        name.hashCode ^
        type.hashCode;
  }
}
