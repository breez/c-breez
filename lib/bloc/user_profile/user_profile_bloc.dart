import 'dart:async';
import 'dart:io';

import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/services/breez_server.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

const PROFILE_DATA_FOLDER_PATH = "profile";

class UserProfileBloc extends Cubit<UserProfileState> with HydratedMixin {
  final BreezServer _breezServer;
  final Notifications _notifications;

  UserProfileBloc(this._breezServer, this._notifications)
      : super(UserProfileState.initial());

  Future registerForNotifications() async {
    String? token = await _notifications.getToken();
    if (token != null) {
      var userID = await _breezServer.registerDevice(token, token);
      emit(state.copyWith(
          profileSettings: state.profileSettings.copyWith(
              token: token, userID: userID, registrationRequested: true)));
    }
  }

  Future<String> uploadImage(List<int> bytes) async {
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
