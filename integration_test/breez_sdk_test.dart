import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/mock/breez_bridge_mock.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('lnurl', () {
    test('parseLnurl', () async {
      const input = "LNURL1DP68GURN8GHJ7MRFVA58GUMPW3EJUCM0D5HKZURF9ASH2ARG9AKXUATJDSHKGMEDD3HKW6TW"
          "8A4NZ0F4VFJRZVMRX5MXGWTYVYMNJDTR8PJRYEFEVD3NSVMXXSCXVVECVYER2ENRVFJKXVEKVYUNVCE4XUUX2E3H"
          "VCEKGEFCVG6KXDFJV9JRYFN5V9NN6MR0VA5KUZPFUCA";
      final result = await BreezSDKMock.parseInput(input: input);
      expect(result, isNotNull);
      // TODO real asserts
    });
  });
}
