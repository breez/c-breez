import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/widgets/mnemonic_seed_list.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'verify_mnemonic_seed_page.dart';

class GenerateMnemonicSeedPage extends StatefulWidget {
  final String mnemonics;

  const GenerateMnemonicSeedPage({Key? key, required this.mnemonics})
      : super(key: key);

  @override
  GenerateMnemonicSeedPageState createState() =>
      GenerateMnemonicSeedPageState();
}

class GenerateMnemonicSeedPageState extends State<GenerateMnemonicSeedPage> {
  late List<String> _mnemonicsList;

  @override
  void initState() {
    _mnemonicsList = widget.mnemonics.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          leading: back_button.BackButton(
            onPressed: () => _onWillPop(context),
          ),
          title: AutoSizeText(
            texts.backup_phrase_generation_write_words,
          ),
        ),
        body: MnemonicSeedList(mnemonicsList: _mnemonicsList),
        bottomNavigationBar: SingleButtonBottomBar(
          text: texts.backup_phrase_warning_action_next,
          onPressed: () {
            Navigator.push(
              context,
              FadeInRoute(
                builder: (_) => VerifyMnemonicSeedPage(widget.mnemonics),
              ),
            );
          },
        ),
      ),
    );
  }

  _onWillPop(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName("/intro"));
  }
}
