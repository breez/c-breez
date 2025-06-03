import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class MoonpayLoading extends StatelessWidget {
  const MoonpayLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Loader(label: texts.add_funds_moonpay_loading)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(texts.add_funds_moonpay_loading),
        ),
      ],
    );
  }
}
