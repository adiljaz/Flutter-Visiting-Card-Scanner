import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikrabyte/controller/controllercard.dart';
import 'package:zikrabyte/theme/theme.dart';
import 'package:zikrabyte/view/home.dart';
import 'package:zikrabyte/widgets/custombutton.dart';
import 'package:zikrabyte/widgets/textformfield.dart';
import '../model/visitingcard.dart';

class ResultPage extends StatefulWidget {
  final String extractedText;

  const ResultPage({super.key, required this.extractedText});

  @override
  // ignore: library_private_types_in_public_api
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  final CardController cardController = Get.find<CardController>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController companyController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: extractName(widget.extractedText));
    phoneController = TextEditingController(text: extractPhone(widget.extractedText));
    emailController = TextEditingController(text: extractEmail(widget.extractedText));
    companyController = TextEditingController(text: extractCompany(widget.extractedText));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companyController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String extractEmail(String text) {
    final emailRegex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    final match = emailRegex.firstMatch(text);
    return match?.group(0) ?? '';
  }

  String extractPhone(String text) {
    final phoneRegex = RegExp(r'(?:\+?(\d{1,3})?[-. (]*)?(?:\(?\d{3}\)?[-. ]*)?\d{3}[-. ]?\d{4,}');
    final matches = phoneRegex.allMatches(text);
    for (var match in matches) {
      String phone = match.group(0) ?? '';
      phone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      if (phone.length >= 7) {
        return phone;
      }
    }
    return '';
  }

  String extractName(String text) {
    final lines = text.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line.isNotEmpty && 
          !line.contains('@') && 
          !RegExp(r'\d{3}[-.\s]?\d{3}[-.\s]?\d{4}').hasMatch(line) &&
          !line.contains('www.') &&
          !line.contains('http') &&
          !RegExp(r'^[0-9\W]+$').hasMatch(line)) {
        return line;
      }
    }
    return '';
  }

  String extractCompany(String text) {
    final lines = text.split('\n');
    bool foundName = false;
    List<String> potentialCompanyNames = [];
    
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || 
          line.contains('@') || 
          line.contains('www.') ||
          line.contains('http') ||
          RegExp(r'\d{3}[-.\s]?\d{3}[-.\s]?\d{4}').hasMatch(line)) {
        continue;
      }
      if (!foundName) {
        foundName = true;
        continue;
      }
      if (line.length > 1 && !RegExp(r'^[0-9\W]+$').hasMatch(line)) {
        potentialCompanyNames.add(line);
      }
    }
    
    return potentialCompanyNames.isNotEmpty 
        ? potentialCompanyNames.reduce((a, b) => a.length > b.length ? a : b) 
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBusinessCard(),
                const SizedBox(height: 24),
                _buildEditForm(),
                const SizedBox(height: 24),
                _buildExtractedTextCard(),
                const SizedBox(height: 24),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Get.back(),
        ), 
          
        const SizedBox(width: 48), // For balance
      ],
    );
  }

  Widget _buildBusinessCard() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameController.text,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    companyController.text,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
                  ),
                  Divider(color: Colors.white.withOpacity(0.5), height: 32),
                  _buildContactInfo(Icons.phone, phoneController.text),
                  const SizedBox(height: 8),
                  _buildContactInfo(Icons.email, emailController.text),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildEditForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            _buildFormField(nameController, 'Full Name', Icons.person),
            _buildFormField(phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
            _buildFormField(emailController, 'Email Address', Icons.email, keyboardType: TextInputType.emailAddress),
            _buildFormField(companyController, 'Company Name', Icons.business),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomTextField(
        controller: controller,
        label: label,
        icon: icon,
        hint: 'Enter $label',
        keyboardType: keyboardType,

      ),
    );
  }

  Widget _buildExtractedTextCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Extracted Text',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              widget.extractedText,
              style: TextStyle(fontSize: 14, color: AppColors.text.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return CustomButton(
      text: 'Save Business Card',
      icon: Icons.save_alt,
      onPressed: _saveCard,
      backgroundColor: AppColors.accent,
      textColor: Colors.white,
    );
  }

  void _saveCard() {
    final card = VisitingCard(
      name: nameController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
      company: companyController.text,
    );
    cardController.saveCard(card);
    Get.off(() => HomePage());
    
    Get.snackbar(
      'Success',
      'Business card saved successfully!',
      backgroundColor: Colors.green[100],
      colorText: Colors.green[900],
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      borderRadius: 10,
    );
  }
}