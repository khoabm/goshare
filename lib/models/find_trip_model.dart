import 'dart:convert';

class FindTripModel {
  final double startLatitude;
  final double startLongitude;
  final String? startAddress;
  final double endLatitude;
  final double endLongitude;
  final String? endAddress;
  final String cartypeId;
  final int paymentMethod;
  FindTripModel({
    required this.startLatitude,
    required this.startLongitude,
    this.startAddress,
    required this.endLatitude,
    required this.endLongitude,
    this.endAddress,
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
