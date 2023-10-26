import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/security/security_bloc.dart';
import 'package:c_breez/routes/security/widget/pin_code_widget.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({
    super.key,
  });

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  String _firstPinCode = "";

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        key: GlobalKey<ScaffoldState>(),
        leading: const back_button.BackButton(),
      ),
      body: PinCodeWidget(
        label: _moment() == _Moment.typing_pin_first_time
            ? texts.security_and_backup_new_pin
            : texts.security_and_backup_new_pin_second_time,
        testPinCodeFunction: (pin) async {
          if (_moment() == _Moment.typing_pin_first_time) {
            setState(() {
              _firstPinCode = pin;
            });
            return const TestPinResult(true, clearOnSuccess: true);
          } else {
            if (pin == _firstPinCode) {
              context.read<SecurityBloc>().setPin(pin);
              Navigator.pop(context);
              return const TestPinResult(true);
            } else {
              setState(() {
                _firstPinCode = "";
              });
              return TestPinResult(false, errorMessage: texts.security_and_backup_new_pin_do_not_match);
            }
          }
        },
      ),
    );
  }

  _Moment _moment() => _firstPinCode.isEmpty ? _Moment.typing_pin_first_time : _Moment.confirming_pin;
}

enum _Moment {
  typing_pin_first_time,
  confirming_pin,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: Directory(
      join((await getApplicationDocumentsDirectory()).path, "preview_storage"),
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SecurityBloc>(
          create: (BuildContext context) => SecurityBloc(),
        ),
      ],
      child: MaterialApp(
        theme: breezLightTheme,
        home: const ChangePinPage(),
      ),
    ),
  );
}
