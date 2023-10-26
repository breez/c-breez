import 'package:flutter/material.dart';

class FillViewPortColumnScrollView extends StatelessWidget {
  final List<Widget> children;

  const FillViewPortColumnScrollView({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
