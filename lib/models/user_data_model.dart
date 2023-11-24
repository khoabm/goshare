import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserDataModel {
  final String accessToken;
  final String refreshToken;
  final String id;
  final String phone;
  final String name;
  final String role;
  final String? currentTrip;
  final List<DependentTrip>? dependentTrips;
  UserDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    this.currentTrip,
    required this.dependentTrips,
  });

  UserDataModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? id,
    String? phone,
    String? name,
    String? role,
    ValueGetter<String?>? currentTrip,
    ValueGetter<List<DependentTrip>?>? dependentTrips,
  }) {
    return UserDataModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      currentTrip: currentTrip?.call() ?? this.currentTrip,
      dependentTrips: dependentTrips?.call() ?? this.dependentTrips,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'id': id,
      'phone': phone,
      'name': name,
      'role': role,
      'currentTrip': currentTrip,
      'dependentTrips': dependentTrips?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      id: map['id'] ?? '',
      phone: map['phone'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? '',
      currentTrip: map['currentTrip'],
      dependentTrips: map['dependentTrips'] != null
          ? List<DependentTrip>.from(
              map['dependentTrips']?.map((x) => DependentTrip.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source));

  // @override
  // String toString() {
  //   return 'UserDataModel(accessToken: $accessToken, refreshToken: $refreshToken, id: $id, phone: $phone, name: $name, role: $role, currentTrip: $currentTrip, dependentTrips: $dependentTrips)';
  // }

  @override
  String toString() {
    return 'UserDataModel(accessToken: $accessToken, refreshToken: $refreshToken, id: $id, phone: $phone, name: $name, role: $role, currentTrip: $currentTrip, dependentTrips: $dependentTrips)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserDataModel &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.id == id &&
        other.phone == phone &&
        other.name == name &&
        other.role == role &&
        other.currentTrip == currentTrip &&
        listEquals(other.dependentTrips, dependentTrips);
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^
        refreshToken.hashCode ^
        id.hashCode ^
        phone.hashCode ^
        name.hashCode ^
        role.hashCode ^
        currentTrip.hashCode ^
        dependentTrips.hashCode;
  }
}

class DependentTrip {
  final String id;
  final String name;
  final String dependentId;
  DependentTrip({
    required this.id,
    required this.name,
    required this.dependentId,
  });

  DependentTrip copyWith({
    String? id,
    String? name,
    String? dependentId,
  }) {
    return DependentTrip(
      id: id ?? this.id,
      name: name ?? this.name,
      dependentId: dependentId ?? this.dependentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dependentId': dependentId,
    };
  }

  factory DependentTrip.fromMap(Map<String, dynamic> map) {
    return DependentTrip(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      dependentId: map['dependentId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DependentTrip.fromJson(String source) =>
      DependentTrip.fromMap(json.decode(source));

  @override
  String toString() =>
      'DependentTrips(id: $id, name: $name, dependentId: $dependentId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DependentTrip &&
        other.id == id &&
        other.name == name &&
        other.dependentId == dependentId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ dependentId.hashCode;
}
