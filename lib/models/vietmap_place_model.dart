import 'dart:convert';

import 'package:flutter/widgets.dart';

class VietmapPlaceModel {
  String? display;
  String? name;
  String? hsNum;
  String? street;
  String? address;
  int? cityId;
  String? city;
  int? districtId;
  String? district;
  int? wardId;
  String? ward;
  double? lat;
  double? lng;
  VietmapPlaceModel({
    this.display,
    this.name,
    this.hsNum,
    this.street,
    this.address,
    this.cityId,
    this.city,
    this.districtId,
    this.district,
    this.wardId,
    this.ward,
    this.lat,
    this.lng,
  });

  VietmapPlaceModel copyWith({
    ValueGetter<String?>? display,
    ValueGetter<String?>? name,
    ValueGetter<String?>? hsNum,
    ValueGetter<String?>? street,
    ValueGetter<String?>? address,
    ValueGetter<int?>? cityId,
    ValueGetter<String?>? city,
    ValueGetter<int?>? districtId,
    ValueGetter<String?>? district,
    ValueGetter<int?>? wardId,
    ValueGetter<String?>? ward,
    ValueGetter<double?>? lat,
    ValueGetter<double?>? lng,
  }) {
    return VietmapPlaceModel(
      display: display?.call() ?? this.display,
      name: name?.call() ?? this.name,
      hsNum: hsNum?.call() ?? this.hsNum,
      street: street?.call() ?? this.street,
      address: address?.call() ?? this.address,
      cityId: cityId?.call() ?? this.cityId,
      city: city?.call() ?? this.city,
      districtId: districtId?.call() ?? this.districtId,
      district: district?.call() ?? this.district,
      wardId: wardId?.call() ?? this.wardId,
      ward: ward?.call() ?? this.ward,
      lat: lat?.call() ?? this.lat,
      lng: lng?.call() ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'display': display,
      'name': name,
      'hsNum': hsNum,
      'street': street,
      'address': address,
      'cityId': cityId,
      'city': city,
      'districtId': districtId,
      'district': district,
      'wardId': wardId,
      'ward': ward,
      'lat': lat,
      'lng': lng,
    };
  }

  factory VietmapPlaceModel.fromMap(Map<String, dynamic> map) {
    return VietmapPlaceModel(
      display: map['display'],
      name: map['name'],
      hsNum: map['hsNum'],
      street: map['street'],
      address: map['address'],
      cityId: map['cityId']?.toInt(),
      city: map['city'],
      districtId: map['districtId']?.toInt(),
      district: map['district'],
      wardId: map['wardId']?.toInt(),
      ward: map['ward'],
      lat: map['lat']?.toDouble(),
      lng: map['lng']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VietmapPlaceModel.fromJson(String source) =>
      VietmapPlaceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VietmapPlaceModel(display: $display, name: $name, hsNum: $hsNum, street: $street, address: $address, cityId: $cityId, city: $city, districtId: $districtId, district: $district, wardId: $wardId, ward: $ward, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VietmapPlaceModel &&
        other.display == display &&
        other.name == name &&
        other.hsNum == hsNum &&
        other.street == street &&
        other.address == address &&
        other.cityId == cityId &&
        other.city == city &&
        other.districtId == districtId &&
        other.district == district &&
        other.wardId == wardId &&
        other.ward == ward &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return display.hashCode ^
        name.hashCode ^
        hsNum.hashCode ^
        street.hashCode ^
        address.hashCode ^
        cityId.hashCode ^
        city.hashCode ^
        districtId.hashCode ^
        district.hashCode ^
        wardId.hashCode ^
        ward.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }
}
