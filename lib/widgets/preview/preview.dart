import 'package:c_breez/widgets/preview/fill_view_port_column_scroll_view.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  final List<Widget> children;

  const Preview(
    this.children, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth ~/ 8;
                  final rows = constraints.maxHeight ~/ 8;
                  return GridView.builder(
                    itemCount: cols * rows + cols,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                    ),
                    itemBuilder: (context, index) {
                      final oddRow = (index ~/ cols).isOdd;
                      final oddCol = (index % cols).isOdd;
                      return Container(
                        color: oddRow == oddCol ? Colors.grey.withAlpha(128) : Colors.blueGrey.withAlpha(128),
                      );
                    },
                  );
                },
              ),
              FillViewPortColumnScrollView(
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
