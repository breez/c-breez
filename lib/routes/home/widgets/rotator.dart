import 'package:c_breez/bloc/backup/backup_bloc.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:c_breez/services/injector.dart';
import 'package:flutter/material.dart';

class Rotator extends StatefulWidget {
  final Widget child;

  const Rotator({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RotatorState();
  }
}

class _RotatorState extends State<Rotator> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final Stream<BackupState> backupStream = BackupBloc(ServiceInjector().breezLib).backupStream;

  _RotatorState();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
        _animationController); //use Tween animation here, to animate between the values of 1.0 & 2.5.
    _animation.addListener(() {
      //here, a listener that rebuilds our widget tree when animation.value changes
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BackupState>(
        stream: backupStream,
        builder: (context, snapshot) {
          if (true /*snapshot.hasData && snapshot.data?.status == BackupStatus.INPROGRESS*/) {
            return RotationTransition(
              turns: _animation,
              child: widget.child,
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
