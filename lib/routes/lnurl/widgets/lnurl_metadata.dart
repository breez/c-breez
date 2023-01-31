import 'dart:convert';

import 'package:flutter/material.dart';

class LNURLMetadata extends StatelessWidget {
  final Map<String, dynamic> metadataMap;

  const LNURLMetadata(this.metadataMap);

  @override
  Widget build(BuildContext context) {
    String? base64String =
        metadataMap['image/png;base64'] ?? metadataMap['image/jpeg;base64'];
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          metadataMap['text/long-desc'] ?? metadataMap['text/plain'],
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        _LNURLMetadataImage(
          base64String: base64String,
        ),
      ],
    );
  }
}

class _LNURLMetadataImage extends StatelessWidget {
  final String? base64String;

  const _LNURLMetadataImage({
    Key? key,
    this.base64String,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (base64String != null) {
      final bytes = base64Decode(base64String!);
      if (bytes.isNotEmpty) {
        return Image.memory(
          bytes,
          width: 128,
        );
      }
    }
    return Container();
  }
}
