import 'dart:async';
import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/user_profile/default_profile_generator.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/services/breez_server.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

const PROFILE_DATA_FOLDER_PATH = "profile";

final _log = FimberLog("UserProfileBloc");

class UserProfileBloc extends Cubit<UserProfileState> with HydratedMixin {
  final BreezServer _breezServer;
  final Notifications _notifications;

  UserProfileBloc(
    this._breezServer,
    this._notifications,
  ) : super(UserProfileState.initial()) {
    stream.listen((profile) {
      _log.v("State: ${profile.profileSettings.toJson()}");
      final settings = profile.profileSettings;
      if (settings.color == null || settings.animal == null) {
        _log.v("Profile has not color or name, generating new random ones…");
        final defaultProfile = generateDefaultProfile();
        emit(profile.copyWith(
          profileSettings: settings.copyWith(
            color: settings.color ?? defaultProfile.color,
            animal: settings.animal ?? defaultProfile.animal,
          ),
        ));
      } else if (settings.name == null) {
        _log.v("Profile has no name, generating new one…");
        emit(profile.copyWith(
          profileSettings: settings.copyWith(
            name: DefaultProfile(
              settings.color!,
              settings.animal!,
            ).buildName(getSystemLocale()),
          ),
        ));
      } else if (!settings.registered) {
        _log.v("Profile has not been registered, registering…");
        registerForNotifications();
      }
    });
    emit(state); // trigger hydration
  }

  Future registerForNotifications() async {
    _log.v("registerForNotifications");
    String? token = await _notifications.getToken();
    if (token != null) {
      _log.v("Got token $token");
      var userID = await _breezServer.registerDevice(token, token);
      emit(state.copyWith(
          profileSettings: state.profileSettings.copyWith(
              token: token, userID: userID, registrationRequested: true)));
    } else {
      _log.w("Failed to get token");
    }
  }

  Future<String> uploadImage(List<int> bytes) async {
    _log.v("uploadImage ${bytes.length}");
    try {
      // TODO upload image to server
      // return await _breezServer.uploadLogo(bytes);
      return await _saveImage(bytes);
    } catch (error) {
      rethrow;
    }
  }

  void updateProfile({
    String? name,
    String? color,
    String? animal,
    String? image,
    bool? registrationRequested,
    bool? hideBalance,
  }) {
    _log.v("updateProfile $name $color $animal $image $registrationRequested $hideBalance");
    var profile = state.profileSettings;
    profile = profile.copyWith(
        name: name ?? profile.name,
        color: color ?? profile.color,
        animal: animal ?? profile.animal,
        image: image ?? profile.image,
        registrationRequested:
            registrationRequested ?? profile.registrationRequested,
        hideBalance: hideBalance ?? profile.hideBalance);
    emit(state.copyWith(profileSettings: profile));
  }

  Future checkVersion() async {
    return _breezServer.checkVersion();
  }

  Future setAdminPassword(String password) async {
    throw Exception("not implemented");
  }

  @override
  UserProfileState fromJson(Map<String, dynamic> json) {
    return UserProfileState(
        profileSettings: UserProfileSettings.fromJson(json));
  }

  @override
  Map<String, dynamic> toJson(UserProfileState state) {
    return state.profileSettings.toJson();
  }

  Future<String> _saveImage(List<int> logoBytes) {
    return getApplicationDocumentsDirectory()
        .then((docDir) =>
            Directory([docDir.path, PROFILE_DATA_FOLDER_PATH].join("/"))
                .create(recursive: true))
        .then((profileDir) => File([
              profileDir.path,
              'profile-${DateTime.now().millisecondsSinceEpoch}-.png'
            ].join("/"))
                .writeAsBytes(logoBytes, flush: true))
        .then((file) => file.path);
  }
}
