import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
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
  final _autoSizeGroup = AutoSizeGroup();
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
        body: _buildMnemonicSeedList(context, 0),
        bottomNavigationBar: _buildNextBtn(context),
      ),
    );
  }

  Row _buildMnemonicSeedList(BuildContext context, int page) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
            6,
            (index) => _buildMnemonicItem(
              context,
              2 * index + (12 * (page)),
              _mnemonicsList[2 * index + (12 * (page))],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
            6,
            (index) => _buildMnemonicItem(
              context,
              1 + 2 * index + 12 * (page),
              _mnemonicsList[1 + 2 * index + 12 * (page)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMnemonicItem(
    BuildContext context,
    int index,
    String mnemonic,
  ) {
    final texts = context.texts();
    return Container(
      height: 48,
      width: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          Text(
            texts.backup_phrase_generation_index(index + 1),
            style: theme.mnemonicSeedTextStyle,
          ),
          Expanded(
            child: AutoSizeText(
              mnemonic,
              style: theme.mnemonicSeedTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextBtn(BuildContext context) {
    final texts = context.texts();
    return SingleButtonBottomBar(
      text: texts.backup_phrase_warning_action_next,
      onPressed: () {
        Navigator.push(
          context,
          FadeInRoute(
            builder: (_) => VerifyMnemonicSeedPage(widget.mnemonics),
          ),
        );
      },
    );
  }

  _onWillPop(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName("/intro"));
  }
}
