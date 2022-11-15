import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_extend/share_extend.dart';

import 'payment_item_avatar.dart';

final AutoSizeGroup _labelGroup = AutoSizeGroup();
final AutoSizeGroup _valueGroup = AutoSizeGroup();

Future<void> showPaymentDetailsDialog(
  BuildContext context,
  LightningTransaction paymentInfo,
) {
  final themeData = Theme.of(context);
  var mediaQuery = MediaQuery.of(context);
  final texts = AppLocalizations.of(context)!;

  AlertDialog paymentDetailsDialog = AlertDialog(
    titlePadding: EdgeInsets.zero,
    title: Stack(
      children: <Widget>[
        Container(
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            color: themeData.isLightTheme
                ? themeData.primaryColorDark
                : themeData.canvasColor,
          ),
          height: 64.0,
          width: mediaQuery.size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Center(
            child: PaymentItemAvatar(
              paymentInfo,
              radius: 32.0,
            ),
          ),
        ),
      ],
    ),
    contentPadding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
    content: SingleChildScrollView(
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, currencyState) {
        return SizedBox(
          width: mediaQuery.size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              paymentInfo.label.isEmpty
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: (paymentInfo.description == null ||
                                paymentInfo.description == "")
                            ? 16
                            : 8,
                      ),
                      child: AutoSizeText(
                        paymentInfo.label.replaceAll("\n", " "),
                        style: themeData.primaryTextTheme.headline5,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
              (paymentInfo.description == null || paymentInfo.description == "")
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 54,
                          minWidth: double.infinity,
                        ),
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: AutoSizeText(
                              paymentInfo.description!,
                              style: themeData.primaryTextTheme.headline4,
                              textAlign: paymentInfo.description!.length > 40 &&
                                      !paymentInfo.description!.contains("\n")
                                  ? TextAlign.start
                                  : TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
              Container(
                height: 36.0,
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AutoSizeText(
                        texts.payment_details_dialog_amount_title,
                        style: themeData.primaryTextTheme.headline4,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        group: _labelGroup,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: _amountText(
                          BitcoinCurrency.fromTickerSymbol(
                              currencyState.bitcoinTicker),
                          paymentInfo,
                          texts,
                          themeData,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 36.0,
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AutoSizeText(
                        texts.payment_details_dialog_date_and_time,
                        style: themeData.primaryTextTheme.headline4,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        group: _labelGroup,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        padding: const EdgeInsets.only(left: 8.0),
                        child: AutoSizeText(
                          BreezDateUtils.formatYearMonthDayHourMinute(
                            DateTime.fromMillisecondsSinceEpoch(
                              paymentInfo.paymentTime * 1000,
                            ),
                          ),
                          style: themeData.primaryTextTheme.headline3,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          group: _valueGroup,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              !paymentInfo.pending
                  ? Container()
                  : Container(
                      height: 36.0,
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: AutoSizeText(
                              texts.payment_details_dialog_expiration,
                              style: themeData.primaryTextTheme.headline4,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              group: _labelGroup,
                            ),
                          ),
                          /* Missing pendingExpirationTimestamp
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              padding: const EdgeInsets.only(left: 8.0),
                              child: AutoSizeText(
                                BreezDateUtils.formatYearMonthDayHourMinute(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    paymentInfo.pendingExpirationTimestamp!
                                            .toInt() *
                                        1000,
                                  ),
                                ),
                                style: themeData.primaryTextTheme.headline3,
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                group: _valueGroup,
                              ),
                            ),
                          ),

                           */
                        ],
                      ),
                    ),
              ..._getPaymentInfoDetails(
                paymentInfo,
                texts,
              ),
            ],
          ),
        );
      }),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(12.0),
        top: Radius.circular(13.0),
      ),
    ),
  );
  return showDialog<void>(
    useRootNavigator: false,
    context: context,
    builder: (_) => paymentDetailsDialog,
  );
}

Widget _amountText(
  BitcoinCurrency currency,
  LightningTransaction paymentInfo,
  AppLocalizations texts,
  ThemeData themeData,
) {
  final amount = currency.format(paymentInfo.amountMsat);

  final text = (paymentInfo.paymentType == "received")
      ? texts.payment_details_dialog_amount_positive(amount)
      : texts.payment_details_dialog_amount_negative(amount);
  return AutoSizeText(
    text,
    style: themeData.primaryTextTheme.headline3,
    textAlign: TextAlign.right,
    maxLines: 1,
    group: _valueGroup,
  );
}

List<Widget> _getPaymentInfoDetails(
  LightningTransaction paymentInfo,
  AppLocalizations texts,
) {
  return _getSinglePaymentInfoDetails(paymentInfo, texts);
}

List<Widget> _getSinglePaymentInfoDetails(
  LightningTransaction paymentInfo,
  AppLocalizations texts,
) {
  return List<Widget>.from({
    paymentInfo.paymentPreimage.isEmpty
        ? Container()
        : ShareablePaymentRow(
      title: texts.payment_details_dialog_single_info_pre_image,
            sharedValue: paymentInfo.paymentPreimage,
          ),
    paymentInfo.destinationPubkey.isEmpty
        ? Container()
        : ShareablePaymentRow(
      title: texts.payment_details_dialog_single_info_node_id,
            sharedValue: paymentInfo.destinationPubkey,
          ),
  });
}

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;

  const ShareablePaymentRow({
    Key? key,
    required this.title,
    required this.sharedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context)!;
    final expansionTileTheme =
        themeData.copyWith(dividerColor: themeData.backgroundColor);
    return Theme(
      data: expansionTileTheme,
      child: ExpansionTile(
        iconColor: themeData.primaryTextTheme.button!.color!,
        collapsedIconColor: themeData.primaryTextTheme.button!.color!,
        title: AutoSizeText(
          title,
          style: themeData.primaryTextTheme.headline4,
          maxLines: 1,
          group: _labelGroup,
        ),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 0.0),
                  child: Text(
                    sharedValue,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                    style: themeData.primaryTextTheme.headline3!
                        .copyWith(fontSize: 10),
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
                        padding: const EdgeInsets.only(right: 8.0),
                        tooltip: texts.payment_details_dialog_copy_action(
                          title,
                        ),
                        iconSize: 16.0,
                        color: themeData.primaryTextTheme.button!.color!,
                        icon: const Icon(
                          IconData(0xe90b, fontFamily: 'icomoon'),
                        ),
                        onPressed: () {
                          ServiceInjector()
                              .device
                              .setClipboardText(sharedValue);
                          Navigator.pop(context);
                          showFlushbar(
                            context,
                            message: texts.payment_details_dialog_copied(
                              title,
                            ),
                            duration: const Duration(seconds: 4),
                          );
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 8.0),
                        tooltip: texts.payment_details_dialog_share_transaction,
                        iconSize: 16.0,
                        color: themeData.primaryTextTheme.button!.color!,
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          ShareExtend.share(sharedValue, "text");
                        },
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
