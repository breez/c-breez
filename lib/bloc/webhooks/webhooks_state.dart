class WebhooksState {
  final String? lnurlPayUrl;
  final String? lnurlPayError;
  final bool isLoading;

  WebhooksState({this.lnurlPayUrl, this.lnurlPayError, this.isLoading = false});

  WebhooksState copyWith({String? lnurlPayUrl, String? lnurlPayError, bool? isLoading}) {
    return WebhooksState(
      lnurlPayUrl: lnurlPayUrl ?? this.lnurlPayUrl,
      lnurlPayError: lnurlPayError ?? this.lnurlPayError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddWebhookRequest {
  final int time;
  final String webhookUrl;
  final String signature;

  AddWebhookRequest({required this.time, required this.webhookUrl, required this.signature});

  Map<String, dynamic> toJson() => {'time': time, 'webhook_url': webhookUrl, 'signature': signature};
}

class RemoveWebhookRequest {
  final int time;
  final String webhookUrl;
  final String signature;

  RemoveWebhookRequest({required this.time, required this.webhookUrl, required this.signature});

  Map<String, dynamic> toJson() => {'time': time, 'webhook_url': webhookUrl, 'signature': signature};
}
