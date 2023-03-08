import 'package:c_breez/config.dart';
import 'package:mockito/mockito.dart';

class LibConfigMock extends Mock implements Config {
  @override
  String defaultMempoolUrl = "https://mempool.space";
}
