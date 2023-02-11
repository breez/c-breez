import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class VerifyMnemonicsDialog extends StatefulWidget {
  const VerifyMnemonicsDialog();

  @override
  VerifyMnemonicsDialogState createState() {
    return VerifyMnemonicsDialogState();
  }
}

class VerifyMnemonicsDialogState extends State<VerifyMnemonicsDialog> {
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();
  bool isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Theme.of(context).canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          "Verify Mnemonics",
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                child: AutoSizeText(
                  "Verify Mnemonics Information Text",
                  style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(fontSize: 16),
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                  group: _autoSizeGroup,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context)
                          .copyWith(unselectedWidgetColor: Theme.of(context).textTheme.labelLarge?.color),
                      child: Checkbox(
                        activeColor: Colors.white,
                        checkColor: Theme.of(context).canvasColor,
                        value: isConfirmed,
                        onChanged: (v) {
                          setState(() {
                            isConfirmed = v!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        texts.alpha_warning_understand,
                        style: Theme.of(context).primaryTextTheme.displaySmall?.copyWith(fontSize: 16),
                        maxLines: 1,
                        minFontSize: MinFontSize(context).minFontSize,
                        stepGranularity: 0.1,
                        group: _autoSizeGroup,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              texts.backup_dialog_option_cancel,
              style: Theme.of(context).primaryTextTheme.labelLarge,
              maxLines: 1,
            ),
          ),
          if (isConfirmed) ...[
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ServiceInjector().keychain.read(CredentialsManager.accountMnemonic).then(
                      (accountMnemonic) => Navigator.pushNamed(
                        context,
                        "/mnemonics",
                        arguments: accountMnemonic,
                      ),
                    );
              },
              child: Text(
                "VERIFY",
                style: Theme.of(context).primaryTextTheme.labelLarge,
                maxLines: 1,
              ),
            )
          ],
        ],
      ),
    );
  }
}
