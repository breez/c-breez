import 'dart:convert';

class BackupScript {
  final String script;
  final String privateKey;

  BackupScript({
    this.script = "",
    this.privateKey = "",
  });

  BackupScript copyWith({
    String? script,
    String? privateKey,
  }) {
    return BackupScript(
      script: script ?? this.script,
      privateKey: privateKey ?? this.privateKey,
    );
  }

  BackupScript.fromJson(
    Map<String, dynamic> json,
  )   : script = json['script'],
        privateKey = json['privateKey'];

  Map<String, dynamic> toJson() => {'script': script, 'privateKey': privateKey};

  @override
  String toString() => jsonEncode(this);
}
