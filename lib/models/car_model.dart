import 'dart:convert';

class CarModel {
  final String cartypeId;
  final int capacity;
  final double totalPrice;
  final String image;
  CarModel({
    required this.cartypeId,
    required this.capacity,
    required this.totalPrice,
    required this.image,
  });

  CarModel copyWith({
    String? cartypeId,
    int? capacity,
    double? totalPrice,
    String? image,
  }) {
    return CarModel(
      cartypeId: cartypeId ?? this.cartypeId,
      capacity: capacity ?? this.capacity,
      totalPrice: totalPrice ?? this.totalPrice,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartypeId': cartypeId,
      'capacity': capacity,
      'totalPrice': totalPrice,
      'image': image,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      cartypeId: map['cartypeId'] ?? '',
      capacity: map['capacity']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) =>
      CarModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CarModel(cartypeId: $cartypeId, capacity: $capacity, totalPrice: $totalPrice, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarModel &&
        other.cartypeId == cartypeId &&
        other.capacity == capacity &&
        other.totalPrice == totalPrice &&
        other.image == image;
  }

  @override
  int get hashCode {
    return cartypeId.hashCode ^
        capacity.hashCode ^
        totalPrice.hashCode ^
        image.hashCode;
  }
}
