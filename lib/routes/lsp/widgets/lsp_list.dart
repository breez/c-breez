import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:flutter/material.dart';

class LspList extends StatefulWidget {
  final List<LspInformation> lspList;
  final LspInformation? selectedLsp;
  final ValueChanged<LspInformation> onSelected;

  const LspList(
      {Key? key,
      required this.lspList,
      required this.selectedLsp,
      required this.onSelected})
      : super(key: key);

  @override
  State<LspList> createState() => _LspListState();
}

class _LspListState extends State<LspList> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

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
                itemCount: widget.lspList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    title: Text(widget.lspList[index].name),
                    selected:
                        widget.selectedLsp?.id == widget.lspList[index].id,
                    trailing: widget.selectedLsp?.id == widget.lspList[index].id
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => widget.onSelected(widget.lspList[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
