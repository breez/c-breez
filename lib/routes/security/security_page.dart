import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/security/widget/mnemonics/security_backup_management.dart';
import 'package:c_breez/routes/security/widget/security_pin_management.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        key: GlobalKey<ScaffoldState>(),
        leading: const back_button.BackButton(),
        title: Text(
          texts.security_and_backup_title,
          style: themeData.appBarTheme.toolbarTextStyle,
        ),
      ),
      body: ListView(
        children: const [
          SecurityPinManagement(),
          SecurityMnemonicsManagement(),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: breezLightTheme,
    home: const SecurityPage(),
  ));
}
