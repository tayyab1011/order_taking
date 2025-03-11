import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double dashLength;
  final double dashGap;
  final Color color;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.dashLength = 5,
    this.dashGap = 3,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.constrainWidth();
          final int dashCount = (width / (dashLength + dashGap)).floor();
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashLength,
                height: thickness,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
