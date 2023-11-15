import 'package:flutter/widgets.dart';

class VietmapAutocompleteModel {
  String? refId;
  String? address;
  String? name;
  String? display;

  VietmapAutocompleteModel({
    this.refId,
    this.address,
    this.name,
    this.display,
  });
  VietmapAutocompleteModel.fromJson(Map<String, dynamic> json) {
    refId = json['ref_id'];
    address = json['address'];
    name = json['name'];
    display = json['display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ref_id'] = refId;
    data['address'] = address;
    data['name'] = name;
    data['display'] = display;
    return data;
  }

  VietmapAutocompleteModel copyWith({
    ValueGetter<String?>? refId,
    ValueGetter<String?>? address,
    ValueGetter<String?>? name,
    ValueGetter<String?>? display,
  }) {
    return VietmapAutocompleteModel(
      refId: refId?.call() ?? this.refId,
      address: address?.call() ?? this.address,
      name: name?.call() ?? this.name,
      display: display?.call() ?? this.display,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'refId': refId,
      'address': address,
      'name': name,
      'display': display,
    };
  }

  factory VietmapAutocompleteModel.fromMap(Map<String, dynamic> map) {
    return VietmapAutocompleteModel(
      refId: map['ref_id'],
      address: map['address'],
      name: map['name'],
      display: map['display'],
    );
  }

  @override
  String toString() {
    return 'VietmapAutocompleteModel(refId: $refId, address: $address, name: $name, display: $display)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VietmapAutocompleteModel &&
        other.refId == refId &&
        other.address == address &&
        other.name == name &&
        other.display == display;
  }

  @override
  int get hashCode {
    return refId.hashCode ^ address.hashCode ^ name.hashCode ^ display.hashCode;
  }
}
