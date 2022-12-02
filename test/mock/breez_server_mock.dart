import 'package:c_breez/services/breez_server.dart';
import 'package:mockito/mockito.dart';

class BreezServerMock extends Mock implements BreezServer {
  @override
  Future<String> registerDevice(String token, String nodeid) {
    return Future<String>.value("1234");
  }
}
