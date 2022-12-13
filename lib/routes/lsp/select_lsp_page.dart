import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/lsp/widgets/lsp_list_widget.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLSPPage extends StatelessWidget {
  final selectedLspController = StreamController<LspInformation?>();

  SelectLSPPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return StreamBuilder(
      stream: selectedLspController.stream,
      builder: (context, snapshot) {
        final error = snapshot.error;
        final selectedLsp = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(texts.account_page_activation_provider_label),
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                // Color needs to be changed
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).appBarTheme.iconTheme?.color,
                ),
              )
            ],
          ),
          body: LspListWidget(
            selectedLsp: selectedLsp,
            onError: (e) {
              if (e.toString() != error?.toString()) {
                selectedLspController.addError(e);
              }
            },
            onSelected: (selectedLsp) => selectedLspController.add(selectedLsp),
          ),
          bottomNavigationBar: _LspActionButton(
            selectedLsp: selectedLsp,
            error: error,
            resetLsp: () => selectedLspController.add(null),
          ),
        );
      },
    );
  }
}

class _LspActionButton extends StatelessWidget {
  final LspInformation? selectedLsp;
  final Object? error;
  final void Function() resetLsp;

  const _LspActionButton({
    Key? key,
    this.selectedLsp,
    required this.error,
    required this.resetLsp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    late final String message;
    late final void Function() onPressed;

    if (error == null && selectedLsp == null) {
      return const SizedBox(
        height: 88,
      );
    }

    if (error != null) {
      message = texts.account_page_activation_action_retry;
      onPressed = resetLsp;
    }
    if (selectedLsp != null) {
      message = texts.account_page_activation_action_select;
      onPressed = () async {
        await _connectToLSP(selectedLsp!, context);
      };
    }

    return SingleButtonBottomBar(
      text: message,
      onPressed: onPressed,
    );
  }

  Future<void> _connectToLSP(
    LspInformation lspInformation,
    BuildContext context,
  ) async {
    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    await context.read<LSPBloc>().connectLSP(lspInformation.id);
    navigator.removeRoute(loaderRoute);
    navigator.pop();
  }
}
