import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/widgets/refund_item.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetRefundPage extends StatefulWidget {
  final RefundBloc refundBloc;

  const GetRefundPage({super.key, required this.refundBloc});

  @override
  State<GetRefundPage> createState() => _GetRefundPageState();
}

class _GetRefundPageState extends State<GetRefundPage> {
  @override
  void initState() {
    super.initState();
    widget.refundBloc.listRefundables();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        title: Text(texts.get_refund_title),
      ),
      body: BlocBuilder<RefundBloc, RefundState>(
        builder: (context, refundState) {
          final refundables = refundState.refundables;
          if (refundables == null || refundables.isEmpty) {
            return Center(
              child: Text(texts.get_refund_no_refundable_items),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: refundables.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: RefundItem(refundables.elementAt(index)),
              );
            },
          );
        },
      ),
    );
  }
}
