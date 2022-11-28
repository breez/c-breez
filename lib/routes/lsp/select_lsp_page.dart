import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLSPPage extends StatefulWidget {
  const SelectLSPPage({
    Key? key,
  }) : super(key: key);

  @override
  SelectLSPPageState createState() {
    return SelectLSPPageState();
  }
}

class SelectLSPPageState extends State<SelectLSPPage> {
  LspInformation? _selectedLSP;
  final _log = FimberLog("LspPage");

  @override
  Widget build(BuildContext context) {
    final lspBloc = context.read<LSPBloc>();
    final texts = context.texts();

    return StreamBuilder<LspInformation?>(
      stream: lspBloc.stream,
      builder: (context, lspStreamSnapshot) {
        return FutureBuilder(
          future: lspBloc.lspList,
          builder: (context, lspListSnapshot) {
            return FutureBuilder(
              future: lspBloc.currentLSP,
              builder: (context, currentLspSnapshot) {
                final error = currentLspSnapshot.error ?? lspStreamSnapshot.error ?? lspListSnapshot.error;

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
                  body: lspListSnapshot.hasData
                      ? error != null
                          ? _error(context, error)
                          : _body(context, currentLspSnapshot.data, lspListSnapshot.data!)
                      : const Center(child: Loader()),
                  bottomNavigationBar: lspListSnapshot.hasData
                      ? _buildBottomButton(context, _selectedLSP ?? currentLspSnapshot.data, error)
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _error(BuildContext context, Object error) {
    _log.i("Error: $error");
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

  Widget _body(
    BuildContext context,
    LspInformation? currentLsp,
    List<LspInformation> lspList,
  ) {
    final texts = context.texts();
    final selectedLSP = _selectedLSP ?? currentLsp;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Text(
              texts.account_page_activation_provider_hint,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: lspList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    selected: selectedLSP?.id == lspList[index].id,
                    trailing: selectedLSP?.id == lspList[index].id ? const Icon(Icons.check) : null,
                    title: Text(lspList[index].name),
                    onTap: () {
                      setState(() {
                        _selectedLSP = lspList[index];
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomButton(
    BuildContext context,
    LspInformation? selectedLSP,
    Object? error,
  ) {
    final texts = context.texts();

    if (error != null) {
      return SingleButtonBottomBar(
        text: texts.account_page_activation_action_retry,
        onPressed: () {
          setState(() {
            _selectedLSP = null;
          });
        },
      );
    }

    if (selectedLSP != null) {
      return SingleButtonBottomBar(
        text: texts.account_page_activation_action_select,
        onPressed: () async {
          await _connectToLSP(selectedLSP);
        },
      );
    }
    return null;
  }

  Future<void> _connectToLSP(LspInformation lspInformation) async {
    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    await context.read<LSPBloc>().connectLSP(lspInformation.id);
    navigator.removeRoute(loaderRoute);
    navigator.pop();
  }
}
