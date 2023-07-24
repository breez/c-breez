import 'package:breez_sdk/breez_bridge.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('lnurl', () {
    test('parseLnurl', () async {
      const input = "LNURL1DP68GURN8GHJ7MRFVA58GUMPW3EJUCM0D5HKZURF9ASH2ARG9AKXUATJDSHKGMEDD3HKW6TW"
          "8A4NZ0F4VFJRZVMRX5MXGWTYVYMNJDTR8PJRYEFEVD3NSVMXXSCXVVECVYER2ENRVFJKXVEKVYUNVCE4XUUX2E3H"
          "VCEKGEFCVG6KXDFJV9JRYFN5V9NN6MR0VA5KUZPFUCA";
      final bridge = BreezSDK();
      final result = await bridge.parseInput(input: input);
      expect(result, isNotNull);
      // TODO real asserts
    });
  });
}
