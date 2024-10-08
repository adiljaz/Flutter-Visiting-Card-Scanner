import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zikrabyte/ocrservice.dart';

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final OCRService _ocrService = OCRService();

  Future<String> captureImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return await _ocrService.processImage(image.path);
    }
    return '';
  }

  Future<String> selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return await _ocrService.processImage(image.path);
    }
    return '';
  }
}
