import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payflow/modules/barcode_scanner/barcode_scanner_status.dart';

class BarcodeScannerController {
  final statusNotifier =
      ValueNotifier<BarcodeScannerStatus>(BarcodeScannerStatus());

  BarcodeScannerStatus get status => statusNotifier.value;
  set status(BarcodeScannerStatus status) => statusNotifier.value = status;

  final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

  void getAvailableCameras() async {
    try {
      final response = await availableCameras();
      final camera = response.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back);
      final cameraController =
          CameraController(camera, ResolutionPreset.max, enableAudio: false);
      await cameraController.initialize();
      status = BarcodeScannerStatus.available(cameraController);
      scanWithCamera();
    } catch (e) {
      status = BarcodeScannerStatus.error(e.toString());
    }
  }

  void scanWithImagePicker() async {
    await status.cameraController!.stopImageStream();
    final response = await ImagePicker().pickImage(source: ImageSource.gallery);
    final inputImage = InputImage.fromFilePath(response!.path);
    scannerBarcode(inputImage);
  }

  void scanWithCamera() {
    Future.delayed(const Duration(seconds: 10)).then((value) {
      if (status.cameraController != null &&
          status.cameraController!.value.isStreamingImages) {
        status.cameraController!.stopImageStream();
      }
      status =
          BarcodeScannerStatus.error("Tempo de leitura de boleto esgotado");
    });
    listenCamera();
  }

  Future<void> scannerBarcode(InputImage inputImage) async {
    try {
      if (status.cameraController != null &&
          status.cameraController!.value.isStreamingImages) {
        status.cameraController!.stopImageStream();
      }
      final barcodes = await barcodeScanner.processImage(inputImage);

      // ignore: prefer_typing_uninitialized_variables
      var barcode;
      for (Barcode item in barcodes) {
        barcode = item.displayValue;
      }

      if (barcode != null && status.barcode.isEmpty) {
        status = BarcodeScannerStatus.barcode(barcode);
        if (status.cameraController != null) status.cameraController!.dispose();
      } else {
        getAvailableCameras();
      }
    } catch (e) {
      print("ERRO NA LEITURA: $e");
    }
  }

  void listenCamera() {
    if (status.cameraController != null &&
        (status.cameraController!.value.isStreamingImages == false)) {
      status.cameraController!.startImageStream((cameraImage) async {
        try {
          final WriteBuffer buffer = WriteBuffer();
          for (Plane plane in cameraImage.planes) {
            buffer.putUint8List(plane.bytes);
          }
          final bytes = buffer.done().buffer.asUint8List();
          final Size imageSize =
              Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
          const InputImageRotation imageRotation =
              InputImageRotation.rotation0deg;
          const InputImageFormat inputImageFormat = InputImageFormat.yuv420;
          final inputImageData = cameraImage.planes.map((Plane plane) {
            return InputImageMetadata(
                bytesPerRow: plane.bytesPerRow,
                rotation: imageRotation,
                format: inputImageFormat,
                size: imageSize);
          }).toList();

          final inputImageCamera =
              InputImage.fromBytes(bytes: bytes, metadata: inputImageData[0]);
          await Future.delayed(const Duration(seconds: 3));
          await scannerBarcode(inputImageCamera);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  void dispose() {
    statusNotifier.dispose();
    barcodeScanner.close();
    if (status.showCamera) status.cameraController!.dispose();
  }
}
