import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/qr_scan/scan_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final _log = Logger("QRScan");

class QRScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRScanState();
  }
}

class QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var popped = false;
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.0,
            top: 0.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: MobileScanner(
                    key: qrKey,
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        _log.info("Barcode detected. ${barcode.displayValue}");
                        if (popped) {
                          _log.info("Skipping, already popped");
                          return;
                        }
                        if (!mounted) {
                          _log.info("Skipping, not mounted");
                          return;
                        }
                        final code = barcode.rawValue;
                        if (code == null) {
                          _log.warning("Failed to scan QR code.");
                        } else {
                          popped = true;
                          _log.info("Popping read QR code: $code");
                          Navigator.of(context).pop(code);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          const ScanOverlay(),
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  right: 10,
                  top: 5,
                  child: ImagePickerButton(cameraController),
                ),
                Positioned(
                  bottom: 30.0,
                  right: 0,
                  left: 0,
                  child: defaultTargetPlatform == TargetPlatform.iOS
                      ? const QRScanCancelButton()
                      : const SizedBox(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ImagePickerButton extends StatelessWidget {
  final MobileScannerController cameraController;

  const ImagePickerButton(
    this.cameraController, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return IconButton(
      padding: const EdgeInsets.fromLTRB(0, 32, 24, 0),
      icon: SvgPicture.asset(
        "src/icon/image.svg",
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcATop,
        ),
        width: 32,
        height: 32,
      ),
      onPressed: () async {
        final picker = ImagePicker();
        // ignore: body_might_complete_normally_catch_error
        final pickedFile = await picker.pickImage(source: ImageSource.gallery).catchError((err) {
          _log.warning("Failed to pick image", err);
        });
        final filePath = pickedFile?.path;
        _log.info("Picked image: $filePath");
        try {
          final found = filePath != null && await cameraController.analyzeImage(filePath);
          if (!found) {
            _log.info("No QR code found in image");
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(texts.qr_scan_gallery_failed),
              ),
            );
          } else {
            _log.info("QR code found in image");
          }
        } catch (err) {
          _log.warning("Failed to analyze image", err);
        }
      },
    );
  }
}

class QRScanCancelButton extends StatelessWidget {
  const QRScanCancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(
              right: 35,
              left: 35,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            texts.qr_scan_action_cancel,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
