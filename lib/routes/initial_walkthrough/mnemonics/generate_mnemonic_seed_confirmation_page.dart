import 'package:auto_size_text/auto_size_text.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'generate_mnemonic_seed_page.dart';

class GenerateMnemonicSeedConfirmationPage extends StatefulWidget {
  @override
  GenerateMnemonicSeedConfirmationPageState createState() =>
      GenerateMnemonicSeedConfirmationPageState();
}

class GenerateMnemonicSeedConfirmationPageState
    extends State<GenerateMnemonicSeedConfirmationPage> {
  bool _isUnderstood = false;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const back_button.BackButton(),
        title: AutoSizeText(
          texts.backup_phrase_generate,
          maxLines: 1,
        ),
      ),
      body: Column(
        children: [
          _buildBackupPhraseImage(),
          _buildInstructions(context),
          _buildCheckbox(context),
          SizedBox(
            height: _isUnderstood ? 0 : 48,
          )
        ],
      ),
      bottomNavigationBar: _buildNextBtn(context, _isUnderstood),
    );
  }

  Widget _buildBackupPhraseImage() {
    return const Expanded(
      flex: 2,
      child: Image(
        image: AssetImage("src/images/generate_backup_phrase.png"),
        height: 100,
        width: 100,
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(
        left: 48,
        right: 48,
      ),
      child: SizedBox(
        height: 96,
        child: AutoSizeText(
          texts.backup_phrase_instructions,
          style: theme.mnemonicSeedInformationTextStyle,
          textAlign: TextAlign.center,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Theme(
            data: themeData.copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: Checkbox(
              activeColor: Colors.white,
              checkColor: themeData.canvasColor,
              value: _isUnderstood,
              onChanged: (value) => setState(() {
                _isUnderstood = value!;
              }),
            ),
          ),
          Text(
            texts.backup_phrase_action_confirm,
            style: theme.mnemonicSeedConfirmationTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildNextBtn(BuildContext context, bool isUnderstood) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isUnderstood
              ? SingleButtonBottomBar(
                  text: texts.backup_phrase_action_next,
                  onPressed: () {
                    String mnemonics = bip39.generateMnemonic(
                      strength: 128,
                    );
                    Navigator.pushReplacement(
                      context,
                      FadeInRoute(
                        builder: (context) =>
                            GenerateMnemonicSeedPage(mnemonics: mnemonics),
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
