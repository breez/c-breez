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

  test("caused by", () {
    final message = extractExceptionMessage(const FfiException(
      "RESULT_ERROR",
      "error sending request for url (https://legend.lnbits.com/withdraw/api/v1/lnurl/cb/ngRuVZspEzjNFNzMFoqBjf?"
          "id_unique_hash=RN8TLkyoxj8GaKgcTTcq4P&k1=FcjuJjwmfXJWhZXYVRpwCL&"
          "pr=lnbc100n1p37zsutsp5pen5py8k4tmh2yntwk63h0w8mzgze3rvnq8mffmh9e37jmw0l5vqpp5t2ax0ahjesquymq4q6kegexcww"
          "8mx6pkxpg3wyd4rjcghwl0dcfqdqdwehh2cmgv4e8xxqyjw5qcqpxrzjqwk7573qcyfskzw33jnvs0shq9tzy28sd86naqlgkdga9p8"
          "z74fs9mmdhw49gpqe6cqqqqlgqqqqqzsqyg9qyysgq5qunm49m4zec3d237xa505djea5pl8v68y2p79lm4437tw0s0mexprzh3qak8"
          "yrprsfz3tww4l2d5lng2877cd92jg5mdnh42ehl70cqmjf7ex): connection closed before message completed Caused "
          "by: connection closed before message completed",
    ));
    expect(
      message,
      'connection closed before message completed',
    );
  });
}
