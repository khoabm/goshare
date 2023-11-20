import 'dart:convert';

class DependentListResponseModel {
  final List<DependentModel> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  DependentListResponseModel({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((x) => x.toMap()).toList(),
      'totalCount': totalCount,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory DependentListResponseModel.fromMap(Map<String, dynamic> map) {
    return DependentListResponseModel(
      items: List<DependentModel>.from(
          map['items']?.map((x) => DependentModel.fromMap(x))),
      totalCount: map['totalCount']?.toInt() ?? 0,
      page: map['page']?.toInt() ?? 0,
      pageSize: map['pageSize']?.toInt() ?? 0,
      totalPages: map['totalPages']?.toInt() ?? 0,
      hasPreviousPage: map['hasPreviousPage'] ?? false,
      hasNextPage: map['hasNextPage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DependentListResponseModel.fromJson(String source) =>
      DependentListResponseModel.fromMap(json.decode(source));

  DependentListResponseModel copyWith({
    List<DependentModel>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return DependentListResponseModel(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  @override
  String toString() {
    return 'DependentListResponseModel(items: $items, totalCount: $totalCount, page: $page, pageSize: $pageSize, totalPages: $totalPages, hasPreviousPage: $hasPreviousPage, hasNextPage: $hasNextPage)';
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is DependentListResponseModel &&
  //       listEquals(other.items, items) &&
  //       other.totalCount == totalCount &&
  //       other.page == page &&
  //       other.pageSize == pageSize &&
  //       other.totalPages == totalPages &&
  //       other.hasPreviousPage == hasPreviousPage &&
  //       other.hasNextPage == hasNextPage;
  // }

  @override
  int get hashCode {
    return items.hashCode ^
        totalCount.hashCode ^
        page.hashCode ^
        pageSize.hashCode ^
        totalPages.hashCode ^
        hasPreviousPage.hashCode ^
        hasNextPage.hashCode;
  }
}

class DependentModel {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final int status;
  final int gender;
  DependentModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.status,
    required this.gender,
  });

  DependentModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? avatarUrl,
    int? status,
    int? gender,
  }) {
    return DependentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'status': status,
      'gender': gender,
    };
  }

  factory DependentModel.fromMap(Map<String, dynamic> map) {
    return DependentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
      status: map['status']?.toInt() ?? 0,
      gender: map['gender']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DependentModel.fromJson(String source) =>
      DependentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DependentModel(id: $id, name: $name, phone: $phone, avatarUrl: $avatarUrl, status: $status, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DependentModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.avatarUrl == avatarUrl &&
        other.status == status &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        avatarUrl.hashCode ^
        status.hashCode ^
        gender.hashCode;
  }
}
