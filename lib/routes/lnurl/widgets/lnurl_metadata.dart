import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class LNURLMetadataText extends StatelessWidget {
  const LNURLMetadataText({
    super.key,
    required this.metadataMap,
  });

  final Map<String, dynamic> metadataMap;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      metadataMap['text/long-desc'] ?? metadataMap['text/plain'],
      style: theme.FieldTextStyle.textStyle,
      maxLines: 1,
      minFontSize: MinFontSize(context).minFontSize,
    );
  }
}

class LNURLMetadataImage extends StatelessWidget {
  final String? base64String;

  const LNURLMetadataImage({
    Key? key,
    this.base64String,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (base64String != null) {
      final bytes = base64Decode(base64String!);
      if (bytes.isNotEmpty) {
        const imageSize = 128.0;
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: imageSize,
            maxHeight: imageSize,
          ),
          child: Image.memory(
            bytes,
            width: imageSize,
            fit: BoxFit.fitWidth,
          ),
        );
      }
    }
    return Container();
  }
}
