import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/widgets/restore_form.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class RestoreFormPage extends StatefulWidget {
  final int currentPage;
  final int lastPage;
  final VoidCallback changePage;
  final List<String> initialWords;

  const RestoreFormPage({
    super.key,
    required this.currentPage,
    required this.lastPage,
    required this.changePage,
    this.initialWords = const [],
  });

  @override
  RestoreFormPageState createState() => RestoreFormPageState();
}

class RestoreFormPageState extends State<RestoreFormPage> {
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> textEditingControllers = List<TextEditingController>.generate(
    12,
    (_) => TextEditingController(),
  );

  late AutovalidateMode _autoValidateMode;
  late bool _hasError;

  @override
  void initState() {
    super.initState();
    _autoValidateMode = AutovalidateMode.disabled;
    _hasError = false;
    for (var i = 0; i < textEditingControllers.length && i < widget.initialWords.length; i++) {
      textEditingControllers[i].text = widget.initialWords[i];
    }
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
              style: themeData.textTheme.headlineMedium?.copyWith(fontSize: 12),
            ),
          ),
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
    final texts = context.texts();
    final mnemonic = textEditingControllers
        .map((controller) => controller.text.toLowerCase().trim())
        .toList()
        .join(" ");
    try {
      Navigator.pop(context, mnemonic);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      throw Exception(extractExceptionMessage(e, texts));
    }
  }
}
