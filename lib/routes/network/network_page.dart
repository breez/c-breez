import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/network/widget/mempool_settings_widget.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        key: GlobalKey<ScaffoldState>(),
        leading: const back_button.BackButton(),
        title: Text(
          texts.network_title,
          style: themeData.appBarTheme.toolbarTextStyle,
        ),
      ),
      body: ListView(
        children: const [
          MempoolSettingsWidget(),
        ],
      ),
    );
  }
}
