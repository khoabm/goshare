import 'dart:convert';

class Place {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final String lat;
  final String lon;
  final String category;
  final String type;
  final int placeRank;
  final double importance;
  final String addressType;
  final String name;
  final String displayName;
  final List<dynamic>? boundingBox;

  Place({
    //required this.displayName,
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.category,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addressType,
    required this.name,
    required this.displayName,
    this.boundingBox,
  });
  // final Address address;
  // final List<String> boundingBox;

  // Place copyWith({
  //   int? placeId,
  //   String? licence,
  //   String? osmType,
  //   int? osmId,
  //   double? lat,
  //   double? lon,
  //   String? category,
  //   String? type,
  //   int? placeRank,
  //   double? importance,
  //   String? addressType,
  //   String? name,
  //   String? displayName,
  //   List<dynamic>? boundingBox,
  // }) {
  //   return Place(
  //     placeId: placeId ?? this.placeId,
  //     licence: licence ?? this.licence,
  //     osmType: osmType ?? this.osmType,
  //     osmId: osmId ?? this.osmId,
  //     lat: lat ?? this.lat,
  //     lon: lon ?? this.lon,
  //     category: category ?? this.category,
  //     type: type ?? this.type,
  //     placeRank: placeRank ?? this.placeRank,
  //     importance: importance ?? this.importance,
  //     addressType: addressType ?? this.addressType,
  //     name: name ?? this.name,
  //     displayName: displayName ?? this.displayName,
  //     boundingBox: boundingBox ?? this.boundingBox,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'licence': licence,
      'osmType': osmType,
      'osmId': osmId,
      'lat': lat,
      'lon': lon,
      'category': category,
      'type': type,
      'placeRank': placeRank,
      'importance': importance,
      'addressType': addressType,
      'name': name,
      'displayName': displayName,
      'boundingBox': boundingBox,
    };
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      placeId: map['placeId']?.toInt() ?? 0,
      licence: map['licence'] ?? '',
      osmType: map['osmType'] ?? '',
      osmId: map['osmId']?.toInt() ?? 0,
      lat: map['lat'] ?? '',
      lon: map['lon'] ?? '',
      category: map['category'] ?? '',
      type: map['type'] ?? '',
      placeRank: map['placeRank']?.toInt() ?? 0,
      importance: map['importance']?.toDouble() ?? 0.0,
      addressType: map['addressType'] ?? '',
      name: map['name'] ?? '',
      displayName: map['display_name'] ?? '',
      // boundingBox: List<dynamic>.from(map['boundingBox']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Place.fromJson(String source) => Place.fromMap(json.decode(source));

  // @override
  // String toString() {
  //   return 'Place(placeId: $placeId, licence: $licence, osmType: $osmType, osmId: $osmId, lat: $lat, lon: $lon, category: $category, type: $type, placeRank: $placeRank, importance: $importance, addressType: $addressType, name: $name, displayName: $displayName, boundingBox: $boundingBox)';
  // }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is Place &&
  //       other.placeId == placeId &&
  //       other.licence == licence &&
  //       other.osmType == osmType &&
  //       other.osmId == osmId &&
  //       other.lat == lat &&
  //       other.lon == lon &&
  //       other.category == category &&
  //       other.type == type &&
  //       other.placeRank == placeRank &&
  //       other.importance == importance &&
  //       other.addressType == addressType &&
  //       other.name == name &&
  //       other.displayName == displayName &&
  //       listEquals(other.boundingBox, boundingBox);
  // }

  // @override
  // int get hashCode {
  //   return placeId.hashCode ^
  //       licence.hashCode ^
  //       osmType.hashCode ^
  //       osmId.hashCode ^
  //       lat.hashCode ^
  //       lon.hashCode ^
  //       category.hashCode ^
  //       type.hashCode ^
  //       placeRank.hashCode ^
  //       importance.hashCode ^
  //       addressType.hashCode ^
  //       name.hashCode ^
  //       displayName.hashCode ^
  //       boundingBox.hashCode;
  // }
}

class Address {
  final String road;
  final String suburb;
  final String village;
  final String city;
  final String county;
  final String state;
  final String iso31662lvl4;
  final String postcode;
  final String country;
  final String countryCode;

  Address({
    required this.road,
    required this.suburb,
    required this.village,
    required this.city,
    required this.county,
    required this.state,
    required this.iso31662lvl4,
    required this.postcode,
    required this.country,
    required this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      road: json['road'],
      suburb: json['suburb'],
      village: json['village'],
      city: json['city'],
      county: json['county'],
      state: json['state'],
      iso31662lvl4: json['ISO3166-2-lvl4'],
      postcode: json['postcode'],
      country: json['country'],
      countryCode: json['country_code'],
    );
  }
}
