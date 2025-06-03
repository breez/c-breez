import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/network/network_settings_bloc.dart';
import 'package:c_breez/bloc/network/network_settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("MempoolSettingsWidget");

class MempoolSettingsWidget extends StatefulWidget {
  const MempoolSettingsWidget({super.key});

  @override
  State<MempoolSettingsWidget> createState() => _MempoolSettingsWidgetState();
}

class _MempoolSettingsWidgetState extends State<MempoolSettingsWidget> {
  final _mempoolUrlController = TextEditingController();
  var _errorOnSave = false;
  var _saving = false;
  var _userChanged = false;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BlocBuilder<NetworkSettingsBloc, NetworkSettingsState>(
      builder: (context, state) {
        _log.info(
          "Building: $state, userChanged: $_userChanged, saving: $_saving, errorOnSave: $_errorOnSave",
        );
        if (_mempoolUrlController.text.isEmpty && !_userChanged) {
          _mempoolUrlController.text = state.mempoolUrl;
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                keyboardType: TextInputType.url,
                controller: _mempoolUrlController,
                decoration: InputDecoration(
                  labelText: texts.mempool_settings_custom_url,
                  errorText: _errorOnSave ? texts.mempool_settings_custom_url_error : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _saving
                    ? [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 14, 26, 0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 1),
                          ),
                        ),
                      ]
                    : [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                          onPressed: () async {
                            _mempoolUrlController.text = "";
                            await context.read<NetworkSettingsBloc>().resetMempoolSpaceSettings();
                            setState(() {
                              _userChanged = false;
                              _errorOnSave = false;
                            });
                          },
                          child: Text(texts.mempool_settings_action_reset),
                        ),
                        const SizedBox(width: 12.0),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                          onPressed: () async {
                            setState(() {
                              _saving = true;
                              _userChanged = true;
                            });
                            final success = await context.read<NetworkSettingsBloc>().setMempoolUrl(
                              _mempoolUrlController.text,
                            );
                            setState(() {
                              _errorOnSave = !success;
                              _saving = false;
                            });
                          },
                          child: Text(texts.mempool_settings_action_save),
                        ),
                      ],
              ),
            ),
          ],
        );
      },
    );
  }
}
