import 'package:c_breez/routes/create_invoice/widgets/animation_properties.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(
        AnimationProperties.COLOR1,
        ColorTween(begin: const Color(0xff8a113a), end: Colors.lightBlue.shade900),
      )
      ..tween(
        AnimationProperties.COLOR2,
        ColorTween(begin: const Color(0xff440216), end: Colors.blue.shade600),
      );

    return CustomAnimationBuilder<dynamic>(
      control: Control.mirror,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [animation!.get(AnimationProperties.COLOR1), animation.get(AnimationProperties.COLOR2)],
            ),
          ),
        );
      },
    );
  }
}
