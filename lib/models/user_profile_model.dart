import 'dart:convert';

class UserProfileModel {
  final String id;
  final String name;
  final String phone;
  final String? avatarUrl;
  final int gender;
  final DateTime birth;
  final bool isDriver;
  UserProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    this.avatarUrl,
    required this.gender,
    required this.birth,
    required this.isDriver,
  });

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? avatarUrl,
    int? gender,
    DateTime? birth,
    bool? isDriver,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      birth: birth ?? this.birth,
      isDriver: isDriver ?? this.isDriver,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'gender': gender,
      'birth': birth.millisecondsSinceEpoch,
      'isDriver': isDriver,
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      avatarUrl: map['avatarUrl'],
      gender: map['gender']?.toInt() ?? 0,
      birth: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['birth']).millisecondsSinceEpoch,
      ),
      isDriver: map['isDriver'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProfileModel(id: $id, name: $name, phone: $phone, avatarUrl: $avatarUrl, gender: $gender, birth: $birth, isDriver: $isDriver)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.avatarUrl == avatarUrl &&
        other.gender == gender &&
        other.birth == birth &&
        other.isDriver == isDriver;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        avatarUrl.hashCode ^
        gender.hashCode ^
        birth.hashCode ^
        isDriver.hashCode;
  }
}
