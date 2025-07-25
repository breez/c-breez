import 'package:c_breez/bloc/user_profile/user_profile_settings.dart';

class UserProfileState {
  final UserProfileSettings profileSettings;

  UserProfileState({required this.profileSettings});

  UserProfileState.initial() : this(profileSettings: UserProfileSettings.initial());

  UserProfileState copyWith({UserProfileSettings? profileSettings}) {
    return UserProfileState(profileSettings: profileSettings ?? this.profileSettings);
  }
}
