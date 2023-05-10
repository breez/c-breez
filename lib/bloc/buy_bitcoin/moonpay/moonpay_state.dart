enum WebViewStatus {
  initial,
  loading,
  success,
  error,
}

abstract class MoonPayState {
  const MoonPayState();

  factory MoonPayState.initial() => const MoonPayStateInitial();

  factory MoonPayState.loading() => const MoonPayStateLoading();

  factory MoonPayState.error(
    String error,
  ) =>
      MoonPayStateError(error);

  factory MoonPayState.urlReady(
    String url,
  ) =>
      MoonPayStateUrlReady(url);

  factory MoonPayState.swapInProgress(
    String address,
    bool expired,
  ) =>
      MoonPayStateSwapInProgress(address, expired);
}

class MoonPayStateInitial extends MoonPayState {
  const MoonPayStateInitial();
}

class MoonPayStateLoading extends MoonPayState {
  const MoonPayStateLoading();
}

class MoonPayStateError extends MoonPayState {
  final String error;

  const MoonPayStateError(
    this.error,
  );
}

class MoonPayStateUrlReady extends MoonPayState {
  final String url;
  final WebViewStatus webViewStatus;

  const MoonPayStateUrlReady(
    this.url, {
    this.webViewStatus = WebViewStatus.initial,
  });

  MoonPayStateUrlReady copyWith({
    String? url,
    WebViewStatus? webViewStatus,
  }) {
    return MoonPayStateUrlReady(
      url ?? this.url,
      webViewStatus: webViewStatus ?? this.webViewStatus,
    );
  }
}

class MoonPayStateSwapInProgress extends MoonPayState {
  final String address;
  final bool expired;

  const MoonPayStateSwapInProgress(
    this.address,
    this.expired,
  );
}
