import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/widgets/mnemonic_seed_list.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'verify_mnemonics_page.dart';

class MnemonicsPage extends StatefulWidget {
  final String mnemonics;

  const MnemonicsPage({Key? key, required this.mnemonics}) : super(key: key);

  @override
  MnemonicsPageState createState() => MnemonicsPageState();
}

class MnemonicsPageState extends State<MnemonicsPage> {
  late List<String> _mnemonicsList;

  @override
  void initState() {
    _mnemonicsList = widget.mnemonics.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
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
              builder: (_) => VerifyMnemonicsPage(widget.mnemonics),
            ),
          );
        },
      ),
    );
  }
}
