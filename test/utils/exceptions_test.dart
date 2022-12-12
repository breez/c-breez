import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('extractExceptionMessage should convert generic error to string', () {
    final message = extractExceptionMessage(Exception("Generic error"));
    expect(message, "Exception: Generic error");
  });

  test('extractExceptionMessage should extract message from FfiException', () {
    final message = extractExceptionMessage(const FfiException(
      "RESULT_ERROR",
      "A message",
    ));
    expect(message, "A message");
  });

  test('extractExceptionMessage should extract inner message from FfiException', () {
    final message = extractExceptionMessage(const FfiException(
      "RESULT_ERROR",
      'status: Internal, message: "A message"',
    ));
    expect(message, "A message");
  });

  test('extractExceptionMessage should extract inner message from FfiException real world case 1', () {
    final message = extractExceptionMessage(const FfiException(
      "RESULT_ERROR",
      "status: Internal, message: \"error calling RPC: RPC error response: RpcError { code: 210, message: \\\""
          "Destination 036af19a240070280278d0a613e7b717bd33dd0f848dc326dfaea2881565bb9d0b is not reachable directly "
          "and all routehints were unusable.\\\", data: None }\"",
    ));
    expect(
      message,
      'Destination 036af19a240070280278d0a613e7b717bd33dd0f848dc326dfaea2881565bb9d0b is not reachable directly and '
      'all routehints were unusable.',
    );
  });
}
