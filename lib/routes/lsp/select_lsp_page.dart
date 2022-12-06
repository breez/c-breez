import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/lsp/widgets/lsp_list_widget.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  LspInformation? _selectedLsp;
  Object? _error;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

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
        selectedLsp: _selectedLsp,
        onError: (error) async {
          if (!await rebuild()) return;
          setState(() {
            _error = error;
          });
        },
        onSelected: (selectedLsp) async {
          if (!await rebuild()) return;
          setState(() {
            _selectedLsp = selectedLsp;
          });
        },
      ),
      bottomNavigationBar: _LspActionButton(
        selectedLsp: _selectedLsp,
        error: _error,
        resetLsp: () {
          setState(() {
            _selectedLsp = null;
          });
        },
      ),
    );
  }

  Future<bool> rebuild() async {
    if (!mounted) return false;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return false;
    }
    return true;
  }
}

class _LspActionButton extends StatelessWidget {
  final LspInformation? selectedLsp;
  final Object? error;
  final Function resetLsp;

  const _LspActionButton(
      {Key? key, this.selectedLsp, required this.error, required this.resetLsp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    late final String message;
    late final Function() onPressed;

    if (error == null && selectedLsp == null) {
      return const SizedBox();
    }

    if (error != null) {
      message = texts.account_page_activation_action_retry;
      onPressed = resetLsp();
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
      LspInformation lspInformation, BuildContext context) async {
    final navigator = Navigator.of(context);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    await context.read<LSPBloc>().connectLSP(lspInformation.id);
    navigator.removeRoute(loaderRoute);
    navigator.pop();
  }
}
