


// ignore_for_file: deprecated_member_use

import 'package:google_ml_kit/google_ml_kit.dart';

class OCRService {
  Future<String> processImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = GoogleMlKit.vision.textRecognizer(); 
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    await textRecognizer.close();

    return text;
  }
}
