import 'dart:convert';

import 'package:flutter/widgets.dart';

class FindTripModel {
  final double startLatitude;
  final double startLongitude;
  final String? startAddress;
  final double endLatitude;
  final double endLongitude;
  final String? endAddress;
  final String cartypeId;
  final int paymentMethod;
  final String? note;
  FindTripModel({
    required this.startLatitude,
    required this.startLongitude,
    this.startAddress,
    required this.endLatitude,
    required this.endLongitude,
    this.endAddress,
    this.note,
    required this.cartypeId,
    required this.paymentMethod,
  });

  FindTripModel copyWith({
    double? startLatitude,
    double? startLongitude,
    String? startAddress,
    double? endLatitude,
    double? endLongitude,
    String? endAddress,
    String? cartypeId,
    String? note,
    int? paymentMethod,
  }) {
    return FindTripModel(
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      startAddress: startAddress ?? this.startAddress,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      endAddress: endAddress ?? this.endAddress,
      cartypeId: cartypeId ?? this.cartypeId,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'startAddress': startAddress,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'endAddress': endAddress,
      'cartypeId': cartypeId,
      'paymentMethod': paymentMethod,
      'note': note,
    };
  }

  factory FindTripModel.fromMap(Map<String, dynamic> map) {
    return FindTripModel(
      startLatitude: map['startLatitude']?.toDouble() ?? 0.0,
      startLongitude: map['startLongitude']?.toDouble() ?? 0.0,
      startAddress: map['startAddress'] ?? '',
      endLatitude: map['endLatitude']?.toDouble() ?? 0.0,
      endLongitude: map['endLongitude']?.toDouble() ?? 0.0,
      endAddress: map['endAddress'] ?? '',
      cartypeId: map['cartypeId'] ?? '',
      note: map['note'] ?? '',
      paymentMethod: map['paymentMethod']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FindTripModel.fromJson(String source) =>
      FindTripModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FindTripModel(startLatitude: $startLatitude, startLongitude: $startLongitude, startAddress: $startAddress, endLatitude: $endLatitude, endLongitude: $endLongitude, endAddress: $endAddress, cartypeId: $cartypeId, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FindTripModel &&
        other.startLatitude == startLatitude &&
        other.startLongitude == startLongitude &&
        other.startAddress == startAddress &&
        other.endLatitude == endLatitude &&
        other.endLongitude == endLongitude &&
        other.endAddress == endAddress &&
        other.cartypeId == cartypeId &&
        other.paymentMethod == paymentMethod;
  }

  @override
  int get hashCode {
    return startLatitude.hashCode ^
        startLongitude.hashCode ^
        startAddress.hashCode ^
        endLatitude.hashCode ^
        endLongitude.hashCode ^
        endAddress.hashCode ^
        cartypeId.hashCode ^
        paymentMethod.hashCode;
  }
}

class FindTripNonAppModel {
  final double startLatitude;
  final double startLongitude;
  final String? startAddress;
  final double endLatitude;
  final double endLongitude;
  final String? endAddress;
  final String cartypeId;
  final int paymentMethod;
  final String? note;
  final DependentInfo dependentInfo;
  FindTripNonAppModel({
    required this.startLatitude,
    required this.startLongitude,
    this.startAddress,
    required this.endLatitude,
    required this.endLongitude,
    this.endAddress,
    required this.cartypeId,
    required this.paymentMethod,
    this.note,
    required this.dependentInfo,
  });

  FindTripNonAppModel copyWith({
    double? startLatitude,
    double? startLongitude,
    String? startAddress,
    double? endLatitude,
    double? endLongitude,
    String? endAddress,
    String? cartypeId,
    String? note,
    int? paymentMethod,
    DependentInfo? dependentInfo,
  }) {
    return FindTripNonAppModel(
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      startAddress: startAddress ?? this.startAddress,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      endAddress: endAddress ?? this.endAddress,
      cartypeId: cartypeId ?? this.cartypeId,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      dependentInfo: dependentInfo ?? this.dependentInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'startAddress': startAddress,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'endAddress': endAddress,
      'cartypeId': cartypeId,
      'paymentMethod': paymentMethod,
      'note': note,
      'dependentInfo': dependentInfo.toMap(),
    };
  }

  factory FindTripNonAppModel.fromMap(Map<String, dynamic> map) {
    return FindTripNonAppModel(
      startLatitude: map['startLatitude']?.toDouble() ?? 0.0,
      startLongitude: map['startLongitude']?.toDouble() ?? 0.0,
      startAddress: map['startAddress'],
      endLatitude: map['endLatitude']?.toDouble() ?? 0.0,
      endLongitude: map['endLongitude']?.toDouble() ?? 0.0,
      endAddress: map['endAddress'],
      cartypeId: map['cartypeId'] ?? '',
      paymentMethod: map['paymentMethod']?.toInt() ?? 0,
      note: map['note'],
      dependentInfo: DependentInfo.fromMap(map['dependentInfo']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FindTripNonAppModel.fromJson(String source) =>
      FindTripNonAppModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FindTripNonAppModel(startLatitude: $startLatitude, startLongitude: $startLongitude, startAddress: $startAddress, endLatitude: $endLatitude, endLongitude: $endLongitude, endAddress: $endAddress, cartypeId: $cartypeId, paymentMethod: $paymentMethod, note: $note, dependentInfo: $dependentInfo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FindTripNonAppModel &&
        other.startLatitude == startLatitude &&
        other.startLongitude == startLongitude &&
        other.startAddress == startAddress &&
        other.endLatitude == endLatitude &&
        other.endLongitude == endLongitude &&
        other.endAddress == endAddress &&
        other.cartypeId == cartypeId &&
        other.paymentMethod == paymentMethod &&
        other.note == note &&
        other.dependentInfo == dependentInfo;
  }

  @override
  int get hashCode {
    return startLatitude.hashCode ^
        startLongitude.hashCode ^
        startAddress.hashCode ^
        endLatitude.hashCode ^
        endLongitude.hashCode ^
        endAddress.hashCode ^
        cartypeId.hashCode ^
        paymentMethod.hashCode ^
        note.hashCode ^
        dependentInfo.hashCode;
  }
}

class DependentInfo {
  final String? phone;
  final String name;
  DependentInfo({
    required this.phone,
    required this.name,
  });

  DependentInfo copyWith({
    ValueGetter<String?>? phone,
    String? name,
  }) {
    return DependentInfo(
      phone: phone?.call() ?? this.phone,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'name': name,
    };
  }

  factory DependentInfo.fromMap(Map<String, dynamic> map) {
    return DependentInfo(
      phone: map['phone'],
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DependentInfo.fromJson(String source) =>
      DependentInfo.fromMap(json.decode(source));

  @override
  String toString() => 'DependentInfo(phone: $phone, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DependentInfo && other.phone == phone && other.name == name;
  }

  @override
  int get hashCode => phone.hashCode ^ name.hashCode;
}
