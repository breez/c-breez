import 'package:c_breez/routes/dev/widget/command.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class RenderBody extends StatelessWidget {
  final bool loading;
  final bool defaults;
  final List<TextSpan> fallback;
  final TextStyle fallbackTextStyle;
  final TextEditingController inputController;
  final FocusNode focusNode;

  const RenderBody({
    this.loading = false,
    this.defaults = false,
    this.fallback = const [],
    this.fallbackTextStyle = const TextStyle(),
    required this.inputController,
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    if (loading) {
      return const Center(
        child: Loader(
          color: Colors.white,
        ),
      );
    }

    if (defaults) {
      return Theme(
        data: themeData.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ListView(
          children: [
            ExpansionTile(
              title: const Text("General"),
              children: [
                Command(
                  "listPeers",
                  (c) => _onCommand(context, c),
                ),
                Command(
                  "listFunds",
                  (c) => _onCommand(context, c),
                ),
                Command(
                  "listPayments",
                  (c) => _onCommand(context, c),
                ),
                Command(
                  "listInvoices",
                  (c) => _onCommand(context, c),
                ),
                Command(
                  "closeAllChannels",
                  (c) => _onCommand(context, c),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        RichText(
          text: TextSpan(
            style: fallbackTextStyle,
            children: fallback,
          ),
        )
      ],
    );
  }

  void _onCommand(BuildContext context, String command) {
    inputController.text = command;
    FocusScope.of(context).requestFocus(focusNode);
  }
}
