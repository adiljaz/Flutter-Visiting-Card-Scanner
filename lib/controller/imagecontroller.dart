import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zikrabyte/service/ocrservice.dart';

class ImageResult {
  final bool success;
  final String text;
  final String? error;

  ImageResult({
    required this.success,
    this.text = '',
    this.error,
  });
}

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final OCRService _ocrService = OCRService();

  Future<ImageResult> captureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image == null) {
        return ImageResult(
          success: false,
          error: 'No image selected',
        );
      }

      return _processImageWithValidation(image);
    } catch (e) {
      return ImageResult(
        success: false,
        error: 'Failed to capture image: ${e.toString()}',
      );
    }
  }

  Future<ImageResult> selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) {
        return ImageResult(
          success: false,
          error: 'No image selected',
        );
      }

      return _processImageWithValidation(image);
    } catch (e) {
      return ImageResult(
        success: false,
        error: 'Failed to select image: ${e.toString()}',
      );
    }
  }

  Future<ImageResult> _processImageWithValidation(XFile image) async {
    try {
      // Validate image size
      final fileSize = await image.length();
      if (fileSize > 10 * 1024 * 1024) { // 10MB limit
        return ImageResult(
          success: false,
          error: 'Image size too large. Please select an image under 10MB.',
        );
      }

      // Process the image
      final result = await _ocrService.processImage(image.path);
      
      if (result.isEmpty) {
        return ImageResult(
          success: false,
          error: 'No text could be extracted from the image. Please try again with a clearer image.',
        );
      }

      return ImageResult(
        success: true,
        text: result,
      );
    } catch (e) {
      return ImageResult(
        success: false,
        error: 'Failed to process image: ${e.toString()}',
      );
    }
  }
}