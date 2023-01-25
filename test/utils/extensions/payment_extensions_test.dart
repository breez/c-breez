import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:breez_translations/generated/breez_translations_en.dart';
import 'package:c_breez/utils/extensions/payment_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Description should be extracted", () {
    const description = "description";
    final extracted = make(description: description).extractTitle(texts());
    expect(extracted, description);
  });

  test("POS sale should be extracted", () {
    const description =
        '|\nJoão Linus | https://storage.googleapis.com/download/storage/v1/b/breez-technology.appspot.com/o/1216%2F7aaf%2F20901c3890fe729e7c6ca30007d770d3760a4829ae9662e60fa97a0b.png?generation=1658427826135832&alt=media  {"payment_hash":"610c5daf49d3ed922260b04d8f8a2857852b19c2de7d1499b14f80d3b3e7c433","label":"","destination_pubkey":"036af19a240070280278d0a613e7b717bd33dd0f848dc326dfaea2881565bb9d0b","payment_preimage":"","keysend":false,"bolt11":"LNBC100N1P3AZD32PP5VYX9MT6F60KEYGNQKPXCLZ3G27ZJKXWZME73FXD3F7QD8VL8CSESD24YP7Q5JN0CW3K7GZVD9H82UEQ0SSXSAR5WPEN5TE0WD6X7UNPVAJJUEM0DANKCETPWP5HXTNRDAKJ7ER0WAHXCMMPVSHHXAR0WFSKWEF0WCCJ7C30VFEX2ET6946X2CMGDEHKCMM80YHXZURSWDCX7APWVDHK6TM09UCNYVFKY5EYVDMPV9NZ2VJXXGCRJVP3VVENSWFSVEJNWV3EV5MKXDNRVYENQVPSXAJRWDESVSENWD3SVY6RSV3EV9JNJD3KXFJNVVRXVYUNWCFSVGH8QMN88ANK2MN9WFSHG6T0DC7NZD348Q6RYDECXGMRZVE48QENYFNPD36R6MT9V35KZCQZPGXQRRSSRZJQVGPTFURJ3528SNX6E3DTWEPAFXW5FPZDYMW9PJ20JJ09SUNNQMWPAPYQQQQQQQQL5QQQQLGQQQQQQGQ9QSP5ZHPA3Y34QS6RGD0Q98KT976Y448D852654V6Z3CE4VGX23GYCAEQ9QYYSSQH09TL9NA50V2V5D222YXUK8NJD347G0ZP6LQSL3G98ZZVXLVDGUXFASAXJXMCGHFY3YSFLE30HTGQHT0SKLAEA7TYS5TRFDP2U6FPAQPEERJ3V"}';
    final extracted = make(description: description).extractTitle(texts());
    expect(extracted, "João Linus");
  });

  test("No description should use state", () {
    final extracted = make().extractTitle(texts());
    expect(extracted, texts().payment_info_title_opened_channel);
  });
}

BreezTranslations texts() => BreezTranslationsEn();

Payment make({
  String? description,
}) =>
    Payment(
      id: "id",
      paymentType: PaymentType.Received,
      paymentTime: 3,
      amountMsat: 2,
      feeMsat: 1,
      pending: false,
      description: description,
      details: PaymentDetails.closedChannel(
        data: ClosedChannelPaymentDetails(
          shortChannelId: "shortChannelId",
          state: ChannelState.Opened,
          fundingTxid: "fundingTxid",
        ),
      ),
    );
