import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';

class LspList extends StatefulWidget {
  final List<LspInformation> lspList;
  final LspInformation? selectedLsp;
  final ValueChanged<LspInformation> onSelected;

  const LspList({super.key, required this.lspList, required this.selectedLsp, required this.onSelected});

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
              padding: EdgeInsets.all(widget.lspList.isEmpty ? 8.0 : 48.0),
              child: widget.lspList.isEmpty
                  ? Center(
                      child: WarningBox(
                        boxPadding: EdgeInsets.zero,
                        contentPadding: const EdgeInsets.all(8),
                        child: AutoSizeText(
                          texts.account_page_activation_provider_unavailable,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          minFontSize: MinFontSize(context).minFontSize,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: false,
                      itemCount: widget.lspList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                          title: Text(widget.lspList[index].name),
                          selected: widget.selectedLsp?.id == widget.lspList[index].id,
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
