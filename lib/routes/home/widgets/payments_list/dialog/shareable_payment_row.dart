import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;
  final AutoSizeGroup? labelAutoSizeGroup;
  final AutoSizeGroup? valueAutoSizeGroup;

  const ShareablePaymentRow({
    Key? key,
    required this.title,
    required this.sharedValue,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final color = themeData.primaryTextTheme.button!.color!;

    return Theme(
      data: themeData.copyWith(
        dividerColor: themeData.backgroundColor,
      ),
      child: ExpansionTile(
        iconColor: color,
        collapsedIconColor: color,
        title: AutoSizeText(
          title,
          style: themeData.primaryTextTheme.headline4,
          maxLines: 1,
          group: labelAutoSizeGroup,
        ),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 0.0),
                  child: Text(
                    sharedValue,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                    style: themeData.primaryTextTheme.headline3!.copyWith(fontSize: 10),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 8.0),
                        tooltip: texts.payment_details_dialog_copy_action(title),
                        iconSize: 16.0,
                        color: color,
                        icon: const Icon(
                          IconData(0xe90b, fontFamily: 'icomoon'),
                        ),
                        onPressed: () {
                          ServiceInjector().device.setClipboardText(sharedValue);
                          Navigator.pop(context);
                          showFlushbar(
                            context,
                            message: texts.payment_details_dialog_copied(title),
                            duration: const Duration(seconds: 4),
                          );
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 8.0),
                        tooltip: texts.payment_details_dialog_share_transaction,
                        iconSize: 16.0,
                        color: color,
                        icon: const Icon(Icons.share),
                        onPressed: () => Share.share(sharedValue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
