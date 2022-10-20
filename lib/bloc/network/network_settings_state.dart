class NetworkSettingsState {
  final String mempoolUrl;

  NetworkSettingsState({
    this.mempoolUrl = "",
  });

  NetworkSettingsState.initial() : this();

  NetworkSettingsState copyWith({
    String? mempoolUrl,
  }) {
    return NetworkSettingsState(
      mempoolUrl: mempoolUrl ?? this.mempoolUrl,
    );
  }

  NetworkSettingsState.fromJson(
    Map<String, dynamic> json,
  ) : mempoolUrl = json['mempoolUrl'];

  Map<String, dynamic> toJson() => {
        'mempoolUrl': mempoolUrl,
      };
}
