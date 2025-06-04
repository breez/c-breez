import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/services/external_browser_service.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final bool trimTitle;
  final String sharedValue;
  final String? urlValue;
  final bool isURL;
  final bool isExpanded;
  final TextStyle? titleTextStyle;
  final TextStyle? childrenTextStyle;
  final EdgeInsets? iconPadding;
  final EdgeInsets? tilePadding;
  final EdgeInsets? childrenPadding;
  final Color? dividerColor;
  final AutoSizeGroup? labelAutoSizeGroup;
  final AutoSizeGroup? valueAutoSizeGroup;
  final bool shouldPop;

  const ShareablePaymentRow({
    required this.title,
    required this.sharedValue,
    super.key,
    this.titleWidget,
    this.urlValue,
    this.isURL = false,
    this.isExpanded = false,
    this.titleTextStyle,
    this.childrenTextStyle,
    this.iconPadding,
    this.tilePadding,
    this.childrenPadding,
    this.dividerColor,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
    this.shouldPop = true,
    this.trimTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final BreezTranslations texts = context.texts();
    final ThemeData themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(dividerColor: dividerColor ?? themeData.customData.paymentListBgColorLight),
      child: ExpansionTile(
        dense: true,
        iconColor: isExpanded ? Colors.transparent : Colors.white,
        collapsedIconColor: Colors.white,
        initiallyExpanded: isExpanded,
        tilePadding: tilePadding,
        title:
            titleWidget ??
            AutoSizeText(
              title,
              style: titleTextStyle ?? themeData.primaryTextTheme.headlineMedium,
              maxLines: 2,
              group: labelAutoSizeGroup,
            ),
        children: <Widget>[
          WarningBox(
            boxPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            backgroundColor: themeData.customData.paymentListBgColorLight,
            borderColor: const Color.fromRGBO(10, 20, 40, 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: childrenPadding ?? EdgeInsets.zero,
                    child: GestureDetector(
                      onTap: isURL
                          ? () => ExternalBrowserService.launchLink(
                              context,
                              linkAddress: urlValue ?? sharedValue,
                            )
                          : null,
                      child: Text(
                        sharedValue,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        maxLines: 4,
                        style:
                            childrenTextStyle ??
                            themeData.primaryTextTheme.displaySmall!.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.156,
                            ),
                      ),
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
                      children: <Widget>[
                        IconButton(
                          alignment: Alignment.centerRight,
                          padding: iconPadding ?? const EdgeInsets.only(right: 8.0),
                          tooltip: texts.payment_details_dialog_copy_action(title),
                          iconSize: 20.0,
                          color: Colors.white,
                          icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                          onPressed: () {
                            ServiceInjector().deviceClient.setClipboardText(sharedValue);
                            if (shouldPop) {
                              Navigator.pop(context);
                            }
                            showFlushbar(
                              context,
                              message: texts.payment_details_dialog_copied(
                                trimTitle ? title.substring(0, title.length - 1) : title,
                              ),
                              duration: const Duration(seconds: 4),
                            );
                          },
                        ),
                        IconButton(
                          padding: iconPadding ?? const EdgeInsets.only(right: 8.0),
                          tooltip: texts.payment_details_dialog_share_transaction,
                          iconSize: 20.0,
                          color: Colors.white,
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            final ShareParams shareParams = ShareParams(
                              title: texts.payment_details_dialog_share_transaction,
                              text: sharedValue,
                            );
                            SharePlus.instance.share(shareParams);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
