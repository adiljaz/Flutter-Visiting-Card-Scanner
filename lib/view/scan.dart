import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zikrabyte/controller/imagecontroller.dart';
import 'package:zikrabyte/theme/theme.dart';
import 'package:zikrabyte/view/result.dart';

class ScanPage extends StatelessWidget {
  final ImageController imageController = Get.put(ImageController());

  // ignore: use_super_parameters
  ScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildScanArea()),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Text(
            'Scan Business Card',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanArea() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card,
            size: 80,
            color: Colors.white.withOpacity(0.8),
          ),
          const SizedBox(height: 24),
          Text(
            'Position the card within frame',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll automatically scan it',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Camera',
              Icons.camera_alt,
              () => _processImage(imageController.captureImage),
              false,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionButton(
              'Gallery',
              Icons.photo_library,
              () => _processImage(imageController.selectImage),
              true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed, bool isOutlined) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isOutlined ? Colors.transparent : AppColors.accent,
        side: isOutlined
            ? const BorderSide(color: Colors.white, width: 2)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isOutlined ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isOutlined ? Colors.white : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(Future<ImageResult> Function() imageFunction) async {
    try {
      // ignore: unused_local_variable
      final loadingDialog = _showLoadingDialog();
      final result = await imageFunction();
      Get.back(); // Close loading dialog

      if (result.success && result.text.isNotEmpty) {
        Get.to(() => ResultPage(extractedText: result.text));
      } else {
        _showErrorDialog(result.error ?? 'Failed to process image');
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred');
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      // ignore: deprecated_member_use
      WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Error',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
} 