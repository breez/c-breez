import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/utils/date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/translations_mock.dart';
import '../unit_logger.dart';

void main() {
  setUpLogger();

  group("title", () {
    test("Title should be extracted", () {
      const description = "description";
      final extracted = make(description: description).title;
      expect(extracted, description);
    });

    test("POS sale should be extracted", () {
      final extracted = make(description: posDescription).title;
      expect(extracted, "João Linus");
    });

    test("No title should use texts fallback", () {
      final extracted = make().title;
      expect(extracted, texts().payment_info_title_opened_channel);
    });

    test("Bitcoin Transfer should be localized", () {
      final extracted = make(description: "Bitcoin Transfer").title;
      expect(extracted, texts().payment_info_title_bitcoin_transfer);
    });
  });

  group("description", () {
    test("Description should be extracted", () {
      const description = "description";
      final extracted = make(description: description).description;
      expect(extracted, description);
    });

    test("POS sale should be extracted", () {
      final extracted = make(description: posDescription).description;
      expect(extracted, "João Linus");
    });

    test("No description should use texts fallback", () {
      final extracted = make().description;
      expect(extracted, texts().payment_info_title_opened_channel);
    });

    test("Bitrefill should be extracted", () {
      const description = "Bitrefill description";
      final extracted = make(description: description).description;
      expect(extracted, "description");
    });
  });

  group("ln payments details", () {
    test("destination pub key when payment is not a ln payment should return empty string", () {
      final destinationPubkey = make().destinationPubkey;
      expect(destinationPubkey, "");
    });

    test("destination pub key when payment is a ln payment should return destination pubkey", () {
      const destinationPubkey = "destinationPubkey";
      final extracted = makeLnPayment(destinationPubkey: destinationPubkey).destinationPubkey;
      expect(extracted, destinationPubkey);
    });

    test("ln address when payment is not a ln payment should return empty string", () {
      final lnAddress = make().lnAddress;
      expect(lnAddress, "");
    });

    test("ln address when payment is a ln payment should return ln address", () {
      const lnAddress = "lnAddress";
      final extracted = makeLnPayment(lnAddress: lnAddress).lnAddress;
      expect(extracted, lnAddress);
    });

    test("payment pre image when payment is not a ln payment should return empty string", () {
      final paymentPreimage = make().paymentPreimage;
      expect(paymentPreimage, "");
    });

    test("payment pre image when payment is a ln payment should return payment pre image", () {
      const paymentPreimage = "paymentPreimage";
      final extracted = makeLnPayment(paymentPreimage: paymentPreimage).paymentPreimage;
      expect(extracted, paymentPreimage);
    });
  });

  group("success action", () {
    test("message when payment is not a ln payment should return empty string", () {
      final successActionMessage = make().successActionMessage;
      expect(successActionMessage, "");
    });

    test("url when payment is not a ln payment should return null", () {
      final successActionUrl = make().successActionUrl;
      expect(successActionUrl, isNull);
    });

    test("message when payment is a ln payment and action is a message should return message", () {
      const successActionMessage = "successActionMessage";
      final extracted = makeLnPayment(
        successActionProcessed: const SuccessActionProcessed.message(
          data: MessageSuccessActionData(
            message: successActionMessage,
          ),
        ),
      ).successActionMessage;
      expect(extracted, successActionMessage);
    });

    test("url when payment is a ln payment and action is a message should return null", () {
      final successActionUrl = makeLnPayment(
        successActionProcessed: const SuccessActionProcessed.message(
          data: MessageSuccessActionData(
            message: "message",
          ),
        ),
      ).successActionUrl;
      expect(successActionUrl, isNull);
    });

    test("message when payment is a ln payment and action is an url should return description", () {
      const successActionDescription = "successActionDescription";
      final extracted = makeLnPayment(
        successActionProcessed: const SuccessActionProcessed.url(
          data: UrlSuccessActionData(
            description: successActionDescription,
            url: "",
          ),
        ),
      ).successActionMessage;
      expect(extracted, successActionDescription);
    });

    test("url when payment is a ln payment and action is an url should return url", () {
      const successActionUrl = "successActionUrl";
      final extracted = makeLnPayment(
        successActionProcessed: const SuccessActionProcessed.url(
          data: UrlSuccessActionData(
            description: "",
            url: successActionUrl,
          ),
        ),
      ).successActionUrl;
      expect(extracted, successActionUrl);
    });

    test("message when payment is a ln payment and action is an aes should return description and data", () {
      const successActionDescription = "successActionDescription";
      const successActionPlainText = "successActionPlainText";
      final extracted = makeLnPayment(
        successActionProcessed: const SuccessActionProcessed.aes(
          result: AesSuccessActionDataResult_Decrypted(
            data: AesSuccessActionDataDecrypted(
              description: successActionDescription,
              plaintext: successActionPlainText,
            ),
          ),
        ),
      ).successActionMessage;
      expect(extracted, "$successActionDescription $successActionPlainText");
    });

    test("url when payment is a ln payment and action is an aes should return null", () {
      final successActionUrl = makeLnPayment(
        successActionProcessed: const SuccessActionProcessed.aes(
          result: AesSuccessActionDataResult_Decrypted(
            data: AesSuccessActionDataDecrypted(
              description: "",
              plaintext: "",
            ),
          ),
        ),
      ).successActionUrl;
      expect(successActionUrl, isNull);
    });
  });

  group("image", () {
    test("metadata img png should be extracted", () {
      final image = makeLnPayment(metadata: '[["image/png;base64", "$imageBase64"]]').image;
      expect(image, isNotNull);
    });

    test("metadata img png when it is empty should return null", () {
      final image = makeLnPayment(metadata: '[["image/png;base64", ""]]').image;
      expect(image, isNull);
    });

    test("metadata img jpeg should be extracted", () {
      final image = makeLnPayment(metadata: '[["image/jpeg;base64", "$imageBase64"]]').image;
      expect(image, isNotNull);
    });

    test("metadata img jpeg when it is empty should return null", () {
      final image = makeLnPayment(metadata: '[["image/jpeg;base64", ""]]').image;
      expect(image, isNull);
    });
  });

  group("simple properties", () {
    test("payment time", () {
      expect(
        make(paymentTime: 123).paymentTime.millisecondsSinceEpoch,
        DateTime.fromMillisecondsSinceEpoch(123000).millisecondsSinceEpoch,
      );
    });

    test("fee sat", () {
      expect(make(feeMilliSat: 123000).feeSat, 123);
    });

    test("amount sat", () {
      expect(make(amountMilliSat: 123000).amountSat, 123);
    });
  });

  group("boolean checkers", () {
    test("hasDescription should return true when description is not null and not empty", () {
      final hasDescription = make(description: "description").hasDescription;
      expect(hasDescription, isTrue);
    });

    test("hasDescription should return false when description is null", () {
      final hasDescription = make(description: null).hasDescription;
      expect(hasDescription, isFalse);
    });

    test("hasDescription should return false when description is empty", () {
      final hasDescription = make(description: "").hasDescription;
      expect(hasDescription, isFalse);
    });

    test("hasMetadata should return true when metadata is not null and not empty", () {
      final hasMetadata = makeLnPayment(metadata: '[["key", "value"]]').hasMetadata;
      expect(hasMetadata, isTrue);
    });

    test("hasMetadata should return false when metadata is null", () {
      final hasMetadata = makeLnPayment(metadata: null).hasMetadata;
      expect(hasMetadata, isFalse);
    });

    test("hasMetadata should return false when metadata is empty", () {
      final hasMetadata = makeLnPayment(metadata: "[]").hasMetadata;
      expect(hasMetadata, isFalse);
    });

    test("hasMetadata should return false when metadata fails to parse", () {
      final hasMetadata = makeLnPayment(metadata: "an invalid json").hasMetadata;
      expect(hasMetadata, isFalse);
    });

    test("isKeySend should return true when payment is a keysend", () {
      final isKeySend = makeLnPayment(keysend: true).isKeySend;
      expect(isKeySend, isTrue);
    });

    test("isKeySend should return false when payment is not a keysend", () {
      final isKeySend = makeLnPayment(keysend: false).isKeySend;
      expect(isKeySend, isFalse);
    });

    test("isKeySend should return false when payment is not a ln payment", () {
      final isKeySend = make().isKeySend;
      expect(isKeySend, isFalse);
    });

    test("expiry should have expiry field when pending payment", () {
      final expiryBlock = makePendingLnPayment().pendingExpirationBlock;
      expect(expiryBlock, 800000);
    });
  });

  test("expiry should not have expiry field when pending complete", () {
    final expiryTime = make().pendingExpirationBlock;
    expect(expiryTime, null);
  });
}

BreezTranslations texts() => TranslationsMock();

PaymentMinutiae make({
  String? description,
  int paymentTime = 3,
  int feeMilliSat = 1,
  int amountMilliSat = 2,
}) =>
    PaymentMinutiae.fromPayment(
      Payment(
        id: "id",
        paymentType: PaymentType.Received,
        paymentTime: paymentTime,
        amountMsat: amountMilliSat,
        feeMsat: feeMilliSat,
        status: PaymentStatus.Complete,
        description: description,
        details: const PaymentDetails.closedChannel(
          data: ClosedChannelPaymentDetails(
            shortChannelId: "shortChannelId",
            state: ChannelState.Opened,
            fundingTxid: "fundingTxid",
          ),
        ),
      ),
      texts(),
    );

PaymentMinutiae makeLnPayment({
  String? metadata,
  bool keysend = false,
  destinationPubkey = "a destination pubkey",
  lnAddress = "a ln address",
  paymentPreimage = "a payment preimage",
  SuccessActionProcessed? successActionProcessed,
}) =>
    PaymentMinutiae.fromPayment(
      Payment(
        id: "id",
        paymentType: PaymentType.Received,
        paymentTime: 3,
        amountMsat: 2,
        feeMsat: 1,
        status: PaymentStatus.Complete,
        description: "description",
        details: PaymentDetails.ln(
          data: LnPaymentDetails(
            paymentHash: "a payment hash",
            label: "a label",
            destinationPubkey: destinationPubkey,
            paymentPreimage: paymentPreimage,
            keysend: keysend,
            bolt11: "a bolt11",
            lnurlSuccessAction: successActionProcessed,
            lnAddress: lnAddress,
            lnurlMetadata: metadata,
          ),
        ),
      ),
      texts(),
    );

PaymentMinutiae makePendingLnPayment({int expiryBlock = 800000}) => PaymentMinutiae.fromPayment(
      Payment(
        id: "id",
        paymentType: PaymentType.Sent,
        paymentTime: 3,
        amountMsat: 2,
        feeMsat: 1,
        status: PaymentStatus.Pending,
        details: PaymentDetails.ln(
          data: LnPaymentDetails(
              bolt11: "a bolt 11",
              paymentHash: "a payment hash",
              label: "a label",
              destinationPubkey: '',
              paymentPreimage: '',
              keysend: false,
              pendingExpirationBlock: expiryBlock),
        ),
      ),
      texts(),
    );

const posDescription = '|\nJoão Linus | https://storage.googleapis.com/download/storage/v1/b/breez-technology'
    '.appspot.com/o/1216%2F7aaf%2F20901c3890fe729e7c6ca30007d770d3760a4829ae9662e60fa97a0b.png?generation=165'
    '8427826135832&alt=media  {"payment_hash":"610c5daf49d3ed922260b04d8f8a2857852b19c2de7d1499b14f80d3b3e7c4'
    '33","label":"","destination_pubkey":"036af19a240070280278d0a613e7b717bd33dd0f848dc326dfaea2881565bb9d0b"'
    ',"payment_preimage":"","keysend":false,"bolt11":"LNBC100N1P3AZD32PP5VYX9MT6F60KEYGNQKPXCLZ3G27ZJKXWZME73'
    'FXD3F7QD8VL8CSESD24YP7Q5JN0CW3K7GZVD9H82UEQ0SSXSAR5WPEN5TE0WD6X7UNPVAJJUEM0DANKCETPWP5HXTNRDAKJ7ER0WAHXC'
    'MMPVSHHXAR0WFSKWEF0WCCJ7C30VFEX2ET6946X2CMGDEHKCMM80YHXZURSWDCX7APWVDHK6TM09UCNYVFKY5EYVDMPV9NZ2VJXXGCRJ'
    'VP3VVENSWFSVEJNWV3EV5MKXDNRVYENQVPSXAJRWDESVSENWD3SVY6RSV3EV9JNJD3KXFJNVVRXVYUNWCFSVGH8QMN88ANK2MN9WFSHG'
    '6T0DC7NZD348Q6RYDECXGMRZVE48QENYFNPD36R6MT9V35KZCQZPGXQRRSSRZJQVGPTFURJ3528SNX6E3DTWEPAFXW5FPZDYMW9PJ20J'
    'J09SUNNQMWPAPYQQQQQQQQL5QQQQLGQQQQQQGQ9QSP5ZHPA3Y34QS6RGD0Q98KT976Y448D852654V6Z3CE4VGX23GYCAEQ9QYYSSQH0'
    '9TL9NA50V2V5D222YXUK8NJD347G0ZP6LQSL3G98ZZVXLVDGUXFASAXJXMCGHFY3YSFLE30HTGQHT0SKLAEA7TYS5TRFDP2U6FPAQPEE'
    'RJ3V"}';

const imageBase64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGwAAABsCAQAAAAlb59GAAACw0lEQVR4Ae3BTYiUBR"
    "gA4Hd0y581cyX/ZlVEx4sRREFUhy79QCJiFGKIkhmmoSYdIjoUezPo51RkUEkm1Cn31kHoEBgUwqalaLqrQpGQRWku6s48QZ+zieuuep"
    "tvep8nUkoppZRSSimllFJKKaWUUkrppqiYYHy0Hx87rV8t2otlCnuiXajo0OFlhd91Rfl5UJ8hVzvvqB4LjYuycsLoLtkdZeW0sR3SFW"
    "Vkh4ax9ZseZWS++z1sqeWe8KRVnrFZj17nNL0W7cRMvyo0zIiyMM5tpunS5XZTTTFJR1zFQ5rWRRmoeMNZIzVc8Ic3VeIy3ypsjzLQ6b"
    "yx3BOX2anwQZSByc4Z3ZC74jK9Cu9FOVjjotGsV4l/meS8witRFibqcoeZZpujqqpbt25V02KY9zU9Gu1BxWI71RVOmRytyDy7HHTYYY"
    "cd8qODvrffN77yheUqMcwkPfoMOONKT0Ur0uGEsTwSw7zkWvrdGa3HRGeMZX0M0+vaBvVEq1HxlobRHDUnhlmm4doueV0lWo17rfC0tZ"
    "71nA2et9EmG22w2pS4gnFWetuHPvGpz/T6Tl3TkPuifbjbL5qOuTXahwlOano8WpNOq2yyxVbbbPOirbbY7AUbrLfGSkstiRE8pmlHtC"
    "KTDbi+rTGCPoUfohVZ60acihHsVPgzWpHF6q5vT4xgh8Jf0Zqs8Lm99tnvgEOO+Mlxxw0Y0O+YIw5417QYwZcKR6KdWGRQYVe0DxV7Na"
    "2OdmGq3ZoGzYoyMF6nLjPMMkdVVVVVt7nmW6BmiQe842//WRutz6vOujn7TIjW52c352sTowycdOMGfeSWKAevumDIkLq6urq6hqa6ur"
    "q6IReds8fsKA8Vsy2wSE1NTU3NdoXf1NTULLLQXFOi7KxT6Iv2YrqjaFgd7UanZeZFSimllFJKKaWUUkoppZRSSin9z/0Dsl3qA0bjx4"
    "sAAAAASUVORK5CYII=";
