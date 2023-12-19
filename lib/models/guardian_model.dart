import 'package:goshare/models/user_profile_model.dart';

class GuardianInfo extends UserProfileModel {
  GuardianInfo({
    required super.id,
    required super.name,
    required super.phone,
    required super.gender,
    required super.birth,
    super.avatarUrl,
    required super.isDriver,
  });
}
