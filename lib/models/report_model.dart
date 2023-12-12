import 'dart:convert';

import 'package:goshare/models/trip_model.dart';

class ReportPostModel {
  final String tripId;
  final String title;
  final String description;
  ReportPostModel({
    required this.tripId,
    required this.title,
    required this.description,
  });

  ReportPostModel copyWith({
    String? tripId,
    String? title,
    String? description,
  }) {
    return ReportPostModel(
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'title': title,
      'description': description,
    };
  }

  factory ReportPostModel.fromMap(Map<String, dynamic> map) {
    return ReportPostModel(
      tripId: map['tripId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportPostModel.fromJson(String source) =>
      ReportPostModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ReportPostModel(tripId: $tripId, title: $title, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportPostModel &&
        other.tripId == tripId &&
        other.title == title &&
        other.description == description;
  }

  @override
  int get hashCode => tripId.hashCode ^ title.hashCode ^ description.hashCode;
}

class Report {
  final String id;
  final String tripId;
  final String title;
  final String description;
  final TripModel trip;
  Report({
    required this.id,
    required this.tripId,
    required this.title,
    required this.description,
    required this.trip,
  });

  Report copyWith({
    String? id,
    String? tripId,
    String? title,
    String? description,
    TripModel? trip,
  }) {
    return Report(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      trip: trip ?? this.trip,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tripId': tripId,
      'title': title,
      'description': description,
      'trip': trip.toMap(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] ?? '',
      tripId: map['tripId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      trip: TripModel.fromMap(map['trip']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) => Report.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Report(id: $id, tripId: $tripId, title: $title, description: $description, trip: $trip)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Report &&
        other.id == id &&
        other.tripId == tripId &&
        other.title == title &&
        other.description == description &&
        other.trip == trip;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tripId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        trip.hashCode;
  }
}
