import 'dart:convert';

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/webhooks/webhooks_state.dart';
import 'package:c_breez/services/notifications.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

class WebhooksBloc extends Cubit<WebhooksState> {
  static const notifierServiceURL = "https://notifier.breez.technology";
  static const lnurlServiceURL = "https://breez.fun";

  final _log = Logger("WebhooksBloc");

  final BreezSDK _breezSDK;
  final BreezPreferences _preferences;
  final NotificationsClient _notifications;

  WebhooksBloc(this._breezSDK, this._preferences, this._notifications) : super(WebhooksState()) {
    _breezSDK.nodeStateStream
        .firstWhere((nodeState) => nodeState != null)
        .then((nodeState) => refreshLnurlPay(nodeState: nodeState!));
  }

  Future refreshLnurlPay({NodeState? nodeState}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final nodeInfo = nodeState ?? await _breezSDK.nodeInfo();
      if (nodeInfo != null) {
        await _registerWebhooks(nodeInfo);
      } else {
        throw Exception("Node state is empty");
      }
    } catch (err) {
      _log.warning("Failed to refresh lnurlpay: $err");
      emit(state.copyWith(lnurlPayError: err.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future _registerWebhooks(NodeState nodeState) async {
    try {
      String webhookUrl = await _generateWebhookURL();
      await _breezSDK.registerWebhook(webhookUrl: webhookUrl);
      _log.info("SDK webhook registered: $webhookUrl");
      final lnurl = await _registerLnurlpay(nodeState, webhookUrl);
      emit(state.copyWith(lnurlPayUrl: lnurl));
    } catch (err) {
      _log.warning("Failed to register webhooks: $err");
      emit(state.copyWith(lnurlPayError: err.toString()));
      rethrow;
    }
  }

  Future<String> _registerLnurlpay(NodeState nodeState, String webhookUrl) async {
    final lastUsedLnurlPay = await _preferences.getLnUrlPayKey();
    if (lastUsedLnurlPay != null && lastUsedLnurlPay != webhookUrl) {
      await _invalidateLnurlPay(nodeState, lastUsedLnurlPay);
    }
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final req = SignMessageRequest(message: "$currentTime-$webhookUrl");
    final signature = await _breezSDK.signMessage(req: req);
    final lnurlWebhookUrl = "$lnurlServiceURL/lnurlpay/${nodeState.id}";
    final uri = Uri.parse(lnurlWebhookUrl);
    final jsonResponse = await http.post(
      uri,
      body: jsonEncode(
        AddWebhookRequest(time: currentTime, webhookUrl: webhookUrl, signature: signature.signature).toJson(),
      ),
    );
    if (jsonResponse.statusCode == 200) {
      final data = jsonDecode(jsonResponse.body);
      final lnurl = data['lnurl'];
      _log.info("lnurlpay webhook registered: $webhookUrl, lnurl = $lnurl");
      await _preferences.setLnUrlPayKey(webhookUrl);
      return lnurl;
    } else {
      throw jsonResponse.body;
    }
  }

  Future<void> _invalidateLnurlPay(NodeState nodeState, String toInvalidate) async {
    final lnurlWebhookUrl = "$lnurlServiceURL/lnurlpay/${nodeState.id}";
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final req = SignMessageRequest(message: "$currentTime-$toInvalidate");
    final signature = await _breezSDK.signMessage(req: req);
    final uri = Uri.parse(lnurlWebhookUrl);
    final response = await http.delete(
      uri,
      body: jsonEncode(
        RemoveWebhookRequest(
          time: currentTime,
          webhookUrl: toInvalidate,
          signature: signature.signature,
        ).toJson(),
      ),
    );
    _log.info("invalidate lnurl pay response: ${response.statusCode}");
    await _preferences.resetLnUrlPayKey();
  }

  Future<String> _generateWebhookURL() async {
    final token = await _notifications.getToken();
    _log.info("Retrieved token, registering…");
    final platform = defaultTargetPlatform == TargetPlatform.iOS
        ? "ios"
        : defaultTargetPlatform == TargetPlatform.android
        ? "android"
        : "";
    if (platform.isEmpty) {
      throw Exception("Notifications for platform is not supported");
    }
    return "$notifierServiceURL/api/v1/notify?platform=$platform&token=$token";
  }
}
