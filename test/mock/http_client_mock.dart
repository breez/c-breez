import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class HttpClientMock extends Mock implements http.Client {
  final getAnswer = <String, http.Response>{};

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final key = url.toString();
    if (getAnswer.containsKey(key)) {
      return getAnswer[key]!;
    }
    return http.Response("Not mocked", 404);
  }
}
