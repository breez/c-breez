import 'package:c_breez/utils/locale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextLocalizations on BuildContext {
  AppLocalizations texts() => AppLocalizations.of(this) ?? getSystemAppLocalizations();
}
