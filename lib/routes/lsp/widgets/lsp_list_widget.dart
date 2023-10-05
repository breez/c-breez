import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/lsp/widgets/lsp_list.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LspListWidget extends StatefulWidget {
  final LspInformation? selectedLsp;
  final ValueChanged<LspInformation> onSelected;
  final ValueChanged<Object> onError;

  const LspListWidget({
    Key? key,
    required this.selectedLsp,
    required this.onSelected,
    required this.onError,
  }) : super(key: key);

  @override
  State<LspListWidget> createState() => _LspListWidgetState();
}

class _LspListWidgetState extends State<LspListWidget> {
  final _log = Logger("LspPage");

  Object? error;

  @override
  Widget build(BuildContext context) {
    final lspBloc = context.read<LSPBloc>();

    return FutureBuilder(
      future: lspBloc.lspList,
      builder: (context, lspListSnapshot) {
        if (!lspListSnapshot.hasData) {
          return const Center(child: Loader(color: Colors.white));
        }

        return FutureBuilder(
          future: lspBloc.fetchCurrentLSP(),
          builder: (context, currentLspSnapshot) {
            error = lspListSnapshot.error;

            if (error != null) {
              _log.severe("Error: $error");
              widget.onError(error!);
              return const _LspErrorText();
            }

            if (widget.selectedLsp == null && currentLspSnapshot.data != null) {
              widget.onSelected(currentLspSnapshot.data!);
            }

            return LspList(
              lspList: lspListSnapshot.data!,
              selectedLsp: widget.selectedLsp,
              onSelected: (selectedLsp) => widget.onSelected(selectedLsp),
            );
          },
        );
      },
    );
  }
}

class _LspErrorText extends StatelessWidget {
  const _LspErrorText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            texts.account_page_activation_error,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
