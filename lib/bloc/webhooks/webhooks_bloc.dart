import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class AddWebhookRequest {
  final int time;
  final String webhookUrl;
  final String signature;

  AddWebhookRequest({required this.time, required this.webhookUrl, required this.signature});

  Map<String, dynamic> toJson() => {
        'time': time,
        'webhook_url': webhookUrl,
        'signature': signature,
      };
}

class RemoveWebhookRequest {
  final int time;
  final String webhookUrl;
  final String signature;

  RemoveWebhookRequest({required this.time, required this.webhookUrl, required this.signature});

  Map<String, dynamic> toJson() => {
        'time': time,
        'webhook_url': webhookUrl,
        'signature': signature,
      };
}

class WebhooksState {
  final String? lnurlpayUrl;
  final String? lnurlPayError;
  final bool loading;

  WebhooksState({this.lnurlpayUrl, this.lnurlPayError, required this.loading});

  WebhooksState copyWith({String? lnurlpayUrl, String? lnurlPayError, bool? loading}) {
    return WebhooksState(
        lnurlpayUrl: lnurlpayUrl ?? this.lnurlpayUrl,
        lnurlPayError: lnurlPayError ?? this.lnurlPayError,
        loading: loading ?? this.loading);
  }
}

class WebhooksBloc extends Cubit<WebhooksState> {
  static const notifierServiceURL = "https://notifier.breez.technology";
  static const lnurlServiceURL = "https://lnurl.breez.technology";

  final _log = Logger("WebhooksBloc");
  final ServiceInjector injector;

  WebhooksBloc(this.injector) : super(WebhooksState(loading: false)) {
    injector.breezSDK.nodeStateStream.firstWhere((nodeState) => nodeState != null).then((nodeState) {
      _withLoadingState(_registerWebhooks(nodeState!));
    });
  }

  Future refreshLnurlPay() async {
    _withLoadingState(() async {
      try {
        final nodeState = await injector.breezSDK.nodeInfo();
        if (nodeState == null) {
          throw Exception("Node state is empty");
        }
        await _registerWebhooks(nodeState);
      } catch (err) {
        _log.warning("Failed to refresh lnurlpay: $err");
        rethrow;
      }
    }());
  }

  Future _registerWebhooks(NodeState nodeState) async {
    try {
      String webhookUrl = await generateWebhookURL();
      await injector.breezSDK.registerWebhook(webhookUrl: webhookUrl);
      _log.info("SDK webhook registered: $webhookUrl");
      final lnurl = await registerLnurlpay(nodeState, webhookUrl);
      emit(state.copyWith(lnurlpayUrl: lnurl));
    } catch (err) {
      _log.warning("Failed to register webhooks: $err");
      emit(state.copyWith(lnurlPayError: err.toString()));
    }
  }

  Future<String> registerLnurlpay(NodeState nodeState, String webhookUrl) async {
    final sharedPrefs = await injector.sharedPreferences;
    var lastUsedLnurlpay = sharedPrefs.getString("lnurlpay_key");
    if (lastUsedLnurlpay != null && lastUsedLnurlpay != webhookUrl) {
      await _invalidateLnurlpay(nodeState, lastUsedLnurlpay);
    }
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final signature =
        await injector.breezSDK.signMessage(req: SignMessageRequest(message: "$currentTime-$webhookUrl"));
    String lnurlWebhookUrl = "$lnurlServiceURL/lnurlpay/${nodeState.id}";
    final uri = Uri.parse(lnurlWebhookUrl);
    final jsonResponse = await http.post(uri,
        body: jsonEncode(AddWebhookRequest(
          time: currentTime,
          webhookUrl: webhookUrl,
          signature: signature.signature,
        ).toJson()));
    if (jsonResponse.statusCode == 200) {
      final data = jsonDecode(jsonResponse.body);
      final lnurl = data['lnurl'];
      _log.info("lnurlpay webhook registered: $webhookUrl, lnurl = $lnurl");
      await sharedPrefs.setString("lnurlpay_key", webhookUrl);
      return lnurl;
    } else {
      throw jsonResponse.body;
    }
  }

  Future _invalidateLnurlpay(NodeState nodeState, String toInvalidate) async {
    final sharedPrefs = await injector.sharedPreferences;
    String lnurlWebhookUrl = "$lnurlServiceURL/lnurlpay/${nodeState.id}";
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final signature =
        await injector.breezSDK.signMessage(req: SignMessageRequest(message: "$currentTime-$toInvalidate"));
    final uri = Uri.parse(lnurlWebhookUrl);
    final response = await http.delete(uri,
        body: jsonEncode(RemoveWebhookRequest(
          time: currentTime,
          webhookUrl: toInvalidate,
          signature: signature.signature,
        ).toJson()));
    _log.info("invalidate lnurl pay response: ${response.statusCode}");
    await sharedPrefs.remove("lnurlpay_key");
  }

  Future<String> generateWebhookURL() async {
    final notifications = injector.notifications;
    String? token = await notifications.getToken();

    _log.info("Retrieved token, registering…");

    String platform = defaultTargetPlatform == TargetPlatform.iOS
        ? "ios"
        : defaultTargetPlatform == TargetPlatform.android
            ? "android"
            : "";
    if (platform.isEmpty) {
      throw Exception("Notifications for platform is not supported");
    }
    return "$notifierServiceURL/api/v1/notify?platform=$platform&token=$token";
  }

  Future _withLoadingState(Future action) {
    emit(state.copyWith(loading: true));
    return action.catchError((err) {
      _log.warning("Failed to register webhooks: $err");
    }).whenComplete(() => emit(state.copyWith(loading: false)));
  }
}
