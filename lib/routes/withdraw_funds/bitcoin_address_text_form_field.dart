import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/bitcoin_address_info.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synchronized/synchronized.dart';

class BitcoinAddressTextFormField extends TextFormField {
  static final _log = FimberLog("BitcoinAddressTextFormField");

  BitcoinAddressTextFormField({
    Key? key,
    required BuildContext context,
    required TextEditingController controller,
    required ValidatorHolder validatorHolder,
  }) : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            labelText: context.texts().withdraw_funds_btc_address,
            suffixIcon: IconButton(
              alignment: Alignment.bottomRight,
              icon: Image(
                image: const AssetImage("src/icon/qr_scan.png"),
                color: theme.BreezColors.white[500],
                fit: BoxFit.contain,
                width: 24.0,
                height: 24.0,
              ),
              tooltip: context.texts().withdraw_funds_scan_barcode,
              onPressed: () async {
                final address = BitcoinAddressInfo.fromScannedString(
                  await Navigator.pushNamed<String>(context, "/qr_scan"),
                ).address;
                if (address != null) {
                  controller.text = address;
                } else {
                  // ignore: use_build_context_synchronously
                  showFlushbar(context, message: context.texts().withdraw_funds_error_qr_code_not_detected);
                }
              },
            ),
          ),
          style: theme.FieldTextStyle.textStyle,
          onChanged: (address) async {
            await validatorHolder.lock.synchronized(() async {
              validatorHolder.valid = await context.read<AccountBloc>().isValidBitcoinAddress(address);
            });
          },
          validator: (address) {
            _log.v("validator called for $address, lock status: ${validatorHolder.lock.locked}");
            if (validatorHolder.valid) {
              return null;
            } else {
              return context.texts().withdraw_funds_error_invalid_address;
            }
          },
        );
}

class ValidatorHolder {
  final lock = Lock();
  var valid = false;
}
