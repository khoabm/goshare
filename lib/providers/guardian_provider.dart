import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/models/user_profile_model.dart';

final guardianProfileProvider =
    StateNotifierProvider<GuardianNotifier, UserProfileModel?>((ref) {
  return GuardianNotifier();
});

class GuardianNotifier extends StateNotifier<UserProfileModel?> {
  GuardianNotifier() : super(null);
  UserProfileModel? get guardianData => state;
  void setGuardianData(Map<String, dynamic> userModel) {
    state = UserProfileModel.fromMap(userModel);
  }

  void setGuardianDataWithModel(UserProfileModel? userModel) {
    state = userModel;
  }
}
