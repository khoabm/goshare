import 'dart:convert';

import 'package:flutter/foundation.dart';

class VietMapRouteModel {
  final String license;
  final String code;
  final List<Path> paths;
  VietMapRouteModel({
    required this.license,
    required this.code,
    required this.paths,
  });

  VietMapRouteModel copyWith({
    String? license,
    String? code,
    List<Path>? paths,
  }) {
    return VietMapRouteModel(
      license: license ?? this.license,
      code: code ?? this.code,
      paths: paths ?? this.paths,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'license': license,
      'code': code,
      'paths': paths.map((x) => x.toMap()).toList(),
    };
  }

  factory VietMapRouteModel.fromMap(Map<String, dynamic> map) {
    return VietMapRouteModel(
      license: map['license'] ?? '',
      code: map['code'] ?? '',
      paths: List<Path>.from(map['paths']?.map((x) => Path.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory VietMapRouteModel.fromJson(String source) =>
      VietMapRouteModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'VietMapRouteModel(license: $license, code: $code, paths: $paths)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VietMapRouteModel &&
        other.license == license &&
        other.code == code &&
        listEquals(other.paths, paths);
  }

  @override
  int get hashCode => license.hashCode ^ code.hashCode ^ paths.hashCode;
}

class Path {
  final double distance;
  final double weight;
  final double time;
  final int transfers;
  final bool pointsEncoded;
  final List<double> bbox;
  final String points;
  final List<Instruction> instructions;
  final String snappedWaypoints;
  Path({
    required this.distance,
    required this.weight,
    required this.time,
    required this.transfers,
    required this.pointsEncoded,
    required this.bbox,
    required this.points,
    required this.instructions,
    required this.snappedWaypoints,
  });

  Path copyWith({
    double? distance,
    double? weight,
    double? time,
    int? transfers,
    bool? pointsEncoded,
    List<double>? bbox,
    String? points,
    List<Instruction>? instructions,
    String? snappedWaypoints,
  }) {
    return Path(
      distance: distance ?? this.distance,
      weight: weight ?? this.weight,
      time: time ?? this.time,
      transfers: transfers ?? this.transfers,
      pointsEncoded: pointsEncoded ?? this.pointsEncoded,
      bbox: bbox ?? this.bbox,
      points: points ?? this.points,
      instructions: instructions ?? this.instructions,
      snappedWaypoints: snappedWaypoints ?? this.snappedWaypoints,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'weight': weight,
      'time': time,
      'transfers': transfers,
      'pointsEncoded': pointsEncoded,
      'bbox': bbox,
      'points': points,
      'instructions': instructions.map((x) => x.toMap()).toList(),
      'snappedWaypoints': snappedWaypoints,
    };
  }

  factory Path.fromMap(Map<String, dynamic> map) {
    return Path(
      distance: map['distance']?.toDouble() ?? 0.0,
      weight: map['weight']?.toDouble() ?? 0.0,
      time: map['time']?.toDouble() ?? 0.0,
      transfers: map['transfers']?.toInt() ?? 0,
      pointsEncoded: map['pointsEncoded'] ?? false,
      bbox: List<double>.from(map['bbox']),
      points: map['points'] ?? '',
      instructions: List<Instruction>.from(
          map['instructions']?.map((x) => Instruction.fromMap(x))),
      snappedWaypoints: map['snappedWaypoints'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Path.fromJson(String source) => Path.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Path(distance: $distance, weight: $weight, time: $time, transfers: $transfers, pointsEncoded: $pointsEncoded, bbox: $bbox, points: $points, instructions: $instructions, snappedWaypoints: $snappedWaypoints)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Path &&
        other.distance == distance &&
        other.weight == weight &&
        other.time == time &&
        other.transfers == transfers &&
        other.pointsEncoded == pointsEncoded &&
        listEquals(other.bbox, bbox) &&
        other.points == points &&
        listEquals(other.instructions, instructions) &&
        other.snappedWaypoints == snappedWaypoints;
  }

  @override
  int get hashCode {
    return distance.hashCode ^
        weight.hashCode ^
        time.hashCode ^
        transfers.hashCode ^
        pointsEncoded.hashCode ^
        bbox.hashCode ^
        points.hashCode ^
        instructions.hashCode ^
        snappedWaypoints.hashCode;
  }
}

class Instruction {
  final double distance;
  final int heading;
  final int sign;
  final List<int> interval;
  final String text;
  final int time;
  final String streetName;
  final int? lastHeading;
  Instruction({
    required this.distance,
    required this.heading,
    required this.sign,
    required this.interval,
    required this.text,
    required this.time,
    required this.streetName,
    this.lastHeading,
  });

  Instruction copyWith({
    double? distance,
    int? heading,
    int? sign,
    List<int>? interval,
    String? text,
    int? time,
    String? streetName,
    ValueGetter<int?>? lastHeading,
  }) {
    return Instruction(
      distance: distance ?? this.distance,
      heading: heading ?? this.heading,
      sign: sign ?? this.sign,
      interval: interval ?? this.interval,
      text: text ?? this.text,
      time: time ?? this.time,
      streetName: streetName ?? this.streetName,
      lastHeading: lastHeading?.call() ?? this.lastHeading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'heading': heading,
      'sign': sign,
      'interval': interval,
      'text': text,
      'time': time,
      'streetName': streetName,
      'lastHeading': lastHeading,
    };
  }

  factory Instruction.fromMap(Map<String, dynamic> map) {
    return Instruction(
      distance: map['distance']?.toDouble() ?? 0.0,
      heading: map['heading']?.toInt() ?? 0,
      sign: map['sign']?.toInt() ?? 0,
      interval: List<int>.from(map['interval']),
      text: map['text'] ?? '',
      time: map['time']?.toInt() ?? 0,
      streetName: map['streetName'] ?? '',
      lastHeading: map['lastHeading']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Instruction.fromJson(String source) =>
      Instruction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Instruction(distance: $distance, heading: $heading, sign: $sign, interval: $interval, text: $text, time: $time, streetName: $streetName, lastHeading: $lastHeading)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Instruction &&
        other.distance == distance &&
        other.heading == heading &&
        other.sign == sign &&
        listEquals(other.interval, interval) &&
        other.text == text &&
        other.time == time &&
        other.streetName == streetName &&
        other.lastHeading == lastHeading;
  }

  @override
  int get hashCode {
    return distance.hashCode ^
        heading.hashCode ^
        sign.hashCode ^
        interval.hashCode ^
        text.hashCode ^
        time.hashCode ^
        streetName.hashCode ^
        lastHeading.hashCode;
  }
}
