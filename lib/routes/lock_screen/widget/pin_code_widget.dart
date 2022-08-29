import 'dart:math';

import 'package:c_breez/routes/lock_screen/widget/digit_masked_widget.dart';
import 'package:c_breez/routes/lock_screen/widget/num_pad_widget.dart';
import 'package:c_breez/services/local_auth_service.dart';
import 'package:c_breez/widgets/preview/preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PinCodeWidget extends StatefulWidget {
  final int pinLength;
  final String label;
  final LocalAuthenticationOption localAuthenticationOption;
  final Future<TestPinResult> Function(String pin) testPinCodeFunction;
  final Future<TestPinResult> Function() testBiometricsFunction;

  const PinCodeWidget({
    Key? key,
    this.pinLength = 6,
    required this.label,
    required this.testPinCodeFunction,
    required this.testBiometricsFunction,
    this.localAuthenticationOption = LocalAuthenticationOption.NONE,
  }) : super(key: key);

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  String errorMessage = "";
  String pinCode = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 20,
            child: Center(
              child: SvgPicture.asset(
                "src/images/logo-color.svg",
                width: size.width / 3,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            flex: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.label),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.pinLength,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DigitMaskedWidget(
                        filled: pinCode.length > index,
                      ),
                    ),
                  ),
                ),
                Text(
                  errorMessage,
                  style: theme.textTheme.headline4?.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 50,
            child: NumPadWidget(
              lhsActionKey: ActionKey.Clear,
              rhsActionKey: pinCode.isNotEmpty
                  ? ActionKey.Backspace
                  : widget.localAuthenticationOption.isFacial
                      ? ActionKey.FaceId
                      : widget.localAuthenticationOption.isFingerprint
                          ? ActionKey.Fingerprint
                          : ActionKey.Backspace,
              onDigitPressed: (digit) {
                setState(() {
                  if (pinCode.length < widget.pinLength) {
                    pinCode += digit;
                    errorMessage = "";
                  }
                  if (pinCode.length == widget.pinLength) {
                    widget.testPinCodeFunction(pinCode).then((result) {
                      if (!result.success) {
                        setState(() {
                          errorMessage = result.errorMessage!;
                          pinCode = "";
                        });
                      }
                    });
                  }
                });
              },
              onActionKeyPressed: (action) {
                setState(() {
                  if (action == ActionKey.Clear) {
                    pinCode = "";
                    errorMessage = "";
                  } else if (action == ActionKey.Backspace && pinCode.isNotEmpty) {
                    pinCode = pinCode.substring(0, pinCode.length - 1);
                    errorMessage = "";
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TestPinResult {
  final bool success;
  final String? errorMessage;

  const TestPinResult(
    this.success,
    this.errorMessage,
  ) : assert(success || errorMessage != null, "errorMessage must be provided if success is false");
}

void main() {
  runApp(Preview([
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("Small space, wrong pin code, face id:"),
    ),
    SizedBox(
      height: 280, // anything smaller than this will overflow some pixels
      child: PinCodeWidget(
        label: "First example",
        localAuthenticationOption: LocalAuthenticationOption.FACE_ID,
        testPinCodeFunction: (pin) => SynchronousFuture(
          const TestPinResult(false, "Wrong pin code"),
        ),
        testBiometricsFunction: () => SynchronousFuture(
          const TestPinResult(false, "Wrong pin code"),
        ),
      ),
    ),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("Medium space, correct pin code, fingerprint:"),
    ),
    SizedBox(
      height: 400,
      child: PinCodeWidget(
        label: "Second example",
        localAuthenticationOption: LocalAuthenticationOption.FINGERPRINT,
        testPinCodeFunction: (pin) => SynchronousFuture(
          const TestPinResult(true, null),
        ),
        testBiometricsFunction: () => SynchronousFuture(
          const TestPinResult(true, null),
        ),
      ),
    ),
    const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text("Large space, correct/incorrect randomly, no local auth:"),
    ),
    SizedBox(
      height: 600,
      child: PinCodeWidget(
        label: "Third example",
        localAuthenticationOption: LocalAuthenticationOption.NONE,
        testPinCodeFunction: (pin) async {
          return TestPinResult(Random().nextBool(), "A random error");
        },
        testBiometricsFunction: () async {
          return TestPinResult(Random().nextBool(), "A random error");
        },
      ),
    ),
  ]));
}
