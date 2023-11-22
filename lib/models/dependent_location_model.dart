import 'dart:convert';

class DependentLocationModel {
  final String id;
  final String userId;
  final String address;
  final double latitude;
  final double longitude;
  final int type;
  DependentLocationModel({
    required this.id,
    required this.userId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  DependentLocationModel copyWith({
    String? id,
    String? userId,
    String? address,
    double? latitude,
    double? longitude,
    int? type,
  }) {
    return DependentLocationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
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
      'type': type,
    };
  }

  factory DependentLocationModel.fromMap(Map<String, dynamic> map) {
    return DependentLocationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      address: map['address'] ?? '',
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      type: map['type']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DependentLocationModel.fromJson(String source) =>
      DependentLocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DependentLocationModel(id: $id, userId: $userId, address: $address, latitude: $latitude, longitude: $longitude, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DependentLocationModel &&
        other.id == id &&
        other.userId == userId &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        address.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        type.hashCode;
  }
}
