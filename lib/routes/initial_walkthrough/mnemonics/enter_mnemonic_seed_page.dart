import 'dart:async';

import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/widgets/restore_form_page.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';

class EnterMnemonicSeedPage extends StatefulWidget {
  @override
  EnterMnemonicSeedPageState createState() => EnterMnemonicSeedPageState();
}

class EnterMnemonicSeedPageState extends State<EnterMnemonicSeedPage> {
  late int _currentPage = 1;
  final int _lastPage = 2;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final query = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: back_button.BackButton(
            onPressed: () {
              if (_currentPage == 1) {
                Navigator.pop(context);
              } else if (_currentPage > 1) {
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _currentPage--;
                });
              }
            },
          ),
          title: Text(
            texts.enter_backup_phrase(
              _currentPage.toString(),
              _lastPage.toString(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: query.size.height - kToolbarHeight - query.padding.top,
            child: RestoreFormPage(
              currentPage: _currentPage,
              lastPage: _lastPage,
              changePage: () {
                setState(() {
                  _currentPage++;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_currentPage == 1) {
      return true;
    } else if (_currentPage > 1) {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        _currentPage--;
      });
      return false;
    }
    return false;
  }
}
