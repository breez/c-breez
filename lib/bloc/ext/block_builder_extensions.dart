import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocWidgetBuilder2<State1, State2> = Widget Function(BuildContext context, State1 state1, State2 state2);

class BlocBuilder2<Bloc1 extends StateStreamable<State1>, State1, Bloc2 extends StateStreamable<State2>, State2>
    extends StatelessWidget {
  final BlocWidgetBuilder2<State1, State2> builder;

  const BlocBuilder2({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Bloc1, State1>(builder: (context, state1) {
      return BlocBuilder<Bloc2, State2>(builder: (context, state2) {
        return builder(context, state1, state2);
      });
    });
  }
}
