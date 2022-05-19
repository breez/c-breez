import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/lsp/select_lsp_page.dart';
import 'package:c_breez/routes/select_provider_error_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AccountRequiredActionsIndicator extends StatefulWidget {
  const AccountRequiredActionsIndicator({
    Key? key,
  }) : super(key: key);

  @override
  AccountRequiredActionsIndicatorState createState() {
    return AccountRequiredActionsIndicatorState();
  }
}

class AccountRequiredActionsIndicatorState
    extends State<AccountRequiredActionsIndicator> {
  bool showingBackupDialog = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LSPState>(
      builder: (ctx, lspState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accState) {
            return _build(
              context,
              lspState,
              accState,
            );
          },
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    LSPState lspStatus,
    AccountState accountModel,
  ) {
    final navigatorState = Navigator.of(context);

    List<Widget> warnings = [];
    Int64 walletBalance = accountModel.walletBalance;

    if (walletBalance > 0) {
      warnings.add(
        WarningAction(() => navigatorState.pushNamed("/send_coins")),
      );
    }

    if (lspStatus.selectionRequired == true || lspStatus.connectionStatus == LSPConnectionStatus.notActive) {
      warnings.add(WarningAction(() {
        if (lspStatus.lastConnectionError != null) {
          showProviderErrorDialog(context, () {
            navigatorState.push(FadeInRoute(
              builder: (_) => SelectLSPPage(lstBloc: context.read()),
            ));
          });
        } else {
          navigatorState.pushNamed("/select_lsp");
        }
      }));
    }

    if (warnings.isEmpty) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: warnings,
    );
  }
}

class WarningAction extends StatefulWidget {
  final void Function() onTap;
  final Widget? iconWidget;

  const WarningAction(
    this.onTap, {
    Key? key,
    this.iconWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WarningActionState();
  }
}

class WarningActionState extends State<WarningAction>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    //use Tween animation here, to animate between the values of 1.0 & 2.5.
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController!);
    _animation!.addListener(() {
      //here, a listener that rebuilds our widget tree when animation.value changes
      setState(() {});
    });
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return IconButton(
      iconSize: 45.0,
      padding: EdgeInsets.zero,
      icon: SizedBox(
        width: 45 * _animation!.value,
        child: widget.iconWidget ??
            SvgPicture.asset(
              "src/icon/warning.svg",
              color: themeData.appBarTheme.actionsIconTheme!.color,
            ),
      ),
      tooltip: texts.account_required_actions_backup,
      onPressed: widget.onTap,
    );
  }
}
