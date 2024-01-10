// ignore_for_file: non_constant_identifier_names

import 'package:breez_translations/generated/breez_translations.dart';
import 'package:mockito/mockito.dart';

class TranslationsMock extends Mock implements BreezTranslations {
  @override
  String get payment_info_title_opened_channel => "A payment info title opened channel";

  @override
  String get payment_info_title_bitcoin_transfer => "A payment info title bitcoin transfer";

  @override
  String get wallet_dashboard_payment_item_no_title => "A payment info title pending ln payment";
}
