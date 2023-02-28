import 'package:c_breez/services/lightning_links.dart';
import 'package:mockito/mockito.dart';

class LightningLinksServiceMock extends Mock implements LightningLinksService {
  @override
  Stream<String> get linksNotifications => const Stream<String>.empty();
}
