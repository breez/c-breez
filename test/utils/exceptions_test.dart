import 'package:breez_translations/generated/breez_translations.dart';
import 'package:breez_translations/generated/breez_translations_en.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_test/flutter_test.dart';

import '../unit_logger.dart';

void main() {
  setUpLogger();

  test('extractExceptionMessage should convert generic error to string', () {
    final message = extractExceptionMessage(Exception("Generic error"), _texts());
    expect(message, "Exception: Generic error");
  });

  test('extractExceptionMessage should extract message from FfiException', () {
    final message = extractExceptionMessage(const FfiException("RESULT_ERROR", "A message"), _texts());
    expect(message, "A message");
  });

  test('extractExceptionMessage should extract inner message from FfiException', () {
    final message = extractExceptionMessage(
      const FfiException("RESULT_ERROR", 'status: Internal, message: "A message"'),
      _texts(),
    );
    expect(message, "A message");
  });

  test('extractExceptionMessage should extract inner message from FfiException real world case 1', () {
    final message = extractExceptionMessage(
      const FfiException(
        "RESULT_ERROR",
        "status: Internal, message: \"error calling RPC: RPC error response: RpcError { code: 210, message: \\\""
            "Destination 036af19a240070280278d0a613e7b717bd33dd0f848dc326dfaea2881565bb9d0b is not reachable directly "
            "and all routehints were unusable.\\\", data: None }\"",
      ),
      _texts(),
    );
    expect(
      message,
      'Destination 036af19a240070280278d0a613e7b717bd33dd0f848dc326dfaea2881565bb9d0b is not reachable directly and '
      'all routehints were unusable.',
    );
  });

  test("caused by", () {
    final message = extractExceptionMessage(
      const FfiException(
        "RESULT_ERROR",
        "error sending request for url (https://legend.lnbits.com/withdraw/api/v1/lnurl/cb/ngRuVZspEzjNFNzMFoqBjf?"
            "id_unique_hash=RN8TLkyoxj8GaKgcTTcq4P&k1=FcjuJjwmfXJWhZXYVRpwCL&"
            "pr=lnbc100n1p37zsutsp5pen5py8k4tmh2yntwk63h0w8mzgze3rvnq8mffmh9e37jmw0l5vqpp5t2ax0ahjesquymq4q6kegexcww"
            "8mx6pkxpg3wyd4rjcghwl0dcfqdqdwehh2cmgv4e8xxqyjw5qcqpxrzjqwk7573qcyfskzw33jnvs0shq9tzy28sd86naqlgkdga9p8"
            "z74fs9mmdhw49gpqe6cqqqqlgqqqqqzsqyg9qyysgq5qunm49m4zec3d237xa505djea5pl8v68y2p79lm4437tw0s0mexprzh3qak8"
            "yrprsfz3tww4l2d5lng2877cd92jg5mdnh42ehl70cqmjf7ex): connection closed before message completed Caused "
            "by: connection closed before message completed",
      ),
      _texts(),
    );
    expect(message, 'connection closed before message completed');
  });

  test("dns error", () {
    final message = extractExceptionMessage(
      const FfiException("RESULT_ERROR", """transport error

Caused by:
   0: error trying to connect: dns error: failed to lookup address information: No address associated with hostname
   1: dns error: failed to lookup address information: No address associated with hostname
   2: failed to lookup address information: No address associated with hostname, null) 
<asynchronous suspension>
      """),
      _texts(),
    );
    expect(message, _texts().generic_network_error);
  });

  test("network error", () {
    final message = extractExceptionMessage(const FfiException("RESULT_ERROR", "transport error"), _texts());
    expect(message, _texts().generic_network_error);
  });

  test("ln pay error no route", () {
    final message = extractExceptionMessage(
      const FfiException(
        "RESULT_ERROR",
        "LNPay.co error 400: Unable to pay LN Invoice: FAILURE_REASON_NO_ROUTE",
      ),
      _texts(),
    );
    expect(message, _texts().payment_error_no_route);
  });

  test("os error 104", () {
    final message = extractExceptionMessage(
      const FfiException(
        "RESULT_ERROR",
        "error sending request for url (https://mempool.space/api/blocks/tip/height): "
            "error trying to connect: Connection reset by peer (os error 104)",
      ),
      _texts(),
    );
    expect(message, _texts().generic_network_error);
  });
}

BreezTranslations _texts() => BreezTranslationsEn();
