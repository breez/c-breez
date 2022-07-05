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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          metadataMap['text/long-desc'] ?? metadataMap['text/plain'],
          style: Theme.of(context).textTheme.caption,
        ),
        if (base64String != null) ...[
          Image.memory(
            base64Decode(base64String),
            width: 128,
          )
        ]
      ],
    );
  }
}
