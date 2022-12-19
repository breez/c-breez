import 'dart:async';

import 'package:breez_sdk/native_toolkit.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/widgets/restore_form.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class RestoreFormPage extends StatefulWidget {
  final int currentPage;
  final int lastPage;
  final VoidCallback changePage;

  const RestoreFormPage(
      {required this.currentPage,
      required this.lastPage,
      required this.changePage});

  @override
  RestoreFormPageState createState() => RestoreFormPageState();
}

class RestoreFormPageState extends State<RestoreFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _lnToolkit = getNativeToolkit();

  List<TextEditingController> textEditingControllers =
      List<TextEditingController>.generate(12, (_) => TextEditingController());

  late AutovalidateMode _autoValidateMode;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _autoValidateMode = AutovalidateMode.disabled;
    _hasError = false;
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    final texts = context.texts();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RestoreForm(
          formKey: _formKey,
          currentPage: widget.currentPage,
          lastPage: widget.lastPage,
          textEditingControllers: textEditingControllers,
          autoValidateMode: _autoValidateMode,
        ),
        if (_hasError) ...[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              texts.enter_backup_phrase_error,
              style: themeData.textTheme.headline4?.copyWith(
                fontSize: 12,
              ),
            ),
          )
        ],
        SingleButtonBottomBar(
          text: widget.currentPage + 1 == (widget.lastPage + 1)
              ? texts.enter_backup_phrase_action_restore
              : texts.enter_backup_phrase_action_next,
          onPressed: () {
            setState(() {
              _hasError = false;
              if (_formKey.currentState!.validate() && !_hasError) {
                _autoValidateMode = AutovalidateMode.disabled;
                if (widget.currentPage + 1 == (widget.lastPage + 1)) {
                  _validateMnemonics();
                } else {
                  widget.changePage();
                }
              } else {
                _autoValidateMode = AutovalidateMode.always;
              }
            });
          },
        ),
      ],
    );
  }

  Future _validateMnemonics() async {
    final mnemonic = textEditingControllers
        .map((controller) => controller.text.toLowerCase().trim())
        .toList()
        .join(" ");
    try {
      Navigator.pop(context, await _lnToolkit.mnemonicToSeed(phrase: mnemonic));
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      throw Exception(extractExceptionMessage(e));
    }
  }
}
