import 'dart:async';
import 'dart:io';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/user_profile/default_profile_generator.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/services/breez_server.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

const PROFILE_DATA_FOLDER_PATH = "profile";

final _log = Logger("UserProfileBloc");

class UserProfileBloc extends Cubit<UserProfileState> with HydratedMixin {
  final BreezSDK _breezSDK;
  final BreezServer _breezServer;
  final Notifications _notifications;

  UserProfileBloc(
    this._breezSDK,
    this._breezServer,
    this._notifications,
  ) : super(UserProfileState.initial()) {
    var profile = state;
    _log.info("State: ${profile.profileSettings.toJson()}");
    final settings = profile.profileSettings;
    if (settings.color == null || settings.animal == null || settings.name == null) {
      _log.info("Profile is missing fields, generating new random ones…");
      final defaultProfile = generateDefaultProfile();
      final color = settings.color ?? defaultProfile.color;
      final animal = settings.animal ?? defaultProfile.animal;
      final name = settings.name ?? DefaultProfile(color, animal).buildName(getSystemLocale());
      profile = profile.copyWith(
        profileSettings: settings.copyWith(
          color: color,
          animal: animal,
          name: name,
        ),
      );
    }
    emit(profile);
    _breezSDK.nodeStateStream.firstWhere((nodeState) => nodeState != null).then((_) {
      registerForNotifications();
    });
  }

  Future registerForNotifications() async {
    _log.info("registerForNotifications");
    String? token = await _notifications.getToken();
    if (token != null) {
      _log.info("Retrieved token, registering…");

      String platform = defaultTargetPlatform == TargetPlatform.iOS
          ? "ios"
          : defaultTargetPlatform == TargetPlatform.android
              ? "android"
              : "";
      // Only register webhook on iOS & Android platforms
      if (platform.isNotEmpty) {
        String webhookUrlBase = "https://notifier.breez.technology";
        String webhookUrl = "$webhookUrlBase/api/v1/notify?platform=$platform&token=$token";
        _log.info("Registering webhook: $webhookUrl");
        await _breezSDK.registerWebhook(webhookUrl: webhookUrl);

        // userID field of UserProfileSettings isn't being used anywhere at this stage on C-Breez
        // when it gets utilized again:
        // TODO: randomize a user id after registering for notifications
        String? userID;
        emit(state.copyWith(
          profileSettings: state.profileSettings.copyWith(
            token: token,
            userID: userID, // Unused Field
            registrationRequested: true, // Unused Field
          ),
        ));
      } else {
        // Do not update/remove existing token if platform is not supported
        throw Exception("Notifications for platform is not supported");
      }
    } else {
      _log.warning("Failed to get token");
    }
  }

  Future<String> uploadImage(List<int> bytes) async {
    _log.info("uploadImage ${bytes.length}");
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
    AppMode? appMode,
    bool? expandPreferences,
  }) {
    _log.info(
        "updateProfile $name $color $animal $image $registrationRequested $hideBalance $appMode $expandPreferences");
    var profile = state.profileSettings;
    profile = profile.copyWith(
      name: name ?? profile.name,
      color: color ?? profile.color,
      animal: animal ?? profile.animal,
      image: image ?? profile.image,
      registrationRequested: registrationRequested ?? profile.registrationRequested,
      hideBalance: hideBalance ?? profile.hideBalance,
      appMode: appMode ?? profile.appMode,
      expandPreferences: expandPreferences ?? profile.expandPreferences,
    );
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
    return UserProfileState(profileSettings: UserProfileSettings.fromJson(json));
  }

  @override
  Map<String, dynamic> toJson(UserProfileState state) {
    return state.profileSettings.toJson();
  }

  Future<String> _saveImage(List<int> logoBytes) {
    return getApplicationDocumentsDirectory()
        .then(
          (docDir) => Directory([docDir.path, PROFILE_DATA_FOLDER_PATH].join("/")).create(recursive: true),
        )
        .then(
          (profileDir) => File(
            [profileDir.path, 'profile-${DateTime.now().millisecondsSinceEpoch}-.png'].join("/"),
          ).writeAsBytes(logoBytes, flush: true),
        )
        .then((file) => file.path);
  }
}
