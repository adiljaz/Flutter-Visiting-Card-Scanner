import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikrabyte/controllercard.dart';
import 'package:zikrabyte/visitingcard.dart';

class ResultPage extends StatelessWidget {
  final String extractedText;
  final CardController cardController = Get.find();

  ResultPage({required this.extractedText});

  // Helper method to extract email from text
  String? extractEmail(String text) {
    final emailRegex = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    final match = emailRegex.firstMatch(text);
    return match?.group(0);
  }

  // Helper method to extract phone number from text
  String? extractPhone(String text) {
    final phoneRegex = RegExp(r'[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}');
    final match = phoneRegex.firstMatch(text);
    return match?.group(0);
  }

  // Helper method to extract name from text
  String? extractName(String text) {
    final lines = text.split('\n');
    if (lines.isNotEmpty) {
      for (var line in lines.take(3)) {
        if (!line.contains('@') && 
            !RegExp(r'[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}').hasMatch(line) &&
            !line.contains('www.') &&
            !line.contains('http')) {
          return line.trim();
        }
      }
    }
    return null;
  }

  // Helper method to extract company name
  String? extractCompany(String text) {
    final lines = text.split('\n');
    if (lines.length > 1) {
      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isNotEmpty && 
            !line.contains('@') && 
            !RegExp(r'[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}').hasMatch(line) &&
            !line.contains('www.') &&
            !line.contains('http')) {
          return line;
        }
      }
    }
    return null;
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          color: Colors.indigo[900],
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.indigo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.indigo[400],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: extractName(extractedText) ?? ''
    );
    final TextEditingController phoneController = TextEditingController(
      text: extractPhone(extractedText) ?? ''
    );
    final TextEditingController emailController = TextEditingController(
      text: extractEmail(extractedText) ?? ''
    );
    final TextEditingController companyController = TextEditingController(
      text: extractCompany(extractedText) ?? ''
    );

    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Edit Business Card',
          style: TextStyle(
            color: Colors.indigo[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.indigo[900]),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Preview Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo[400]!, Colors.indigo[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          extractedText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Form Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildFormField(
                        controller: nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                        hint: 'Enter full name',
                      ),
                      _buildFormField(
                        controller: phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone,
                        hint: 'Enter phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      _buildFormField(
                        controller: emailController,
                        label: 'Email Address',
                        icon: Icons.email,
                        hint: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildFormField(
                        controller: companyController,
                        label: 'Company Name',
                        icon: Icons.business,
                        hint: 'Enter company name',
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Save Button
              Container(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    final card = VisitingCard(
                      name: nameController.text,
                      phoneNumber: phoneController.text,
                      email: emailController.text,
                      company: companyController.text,
                    );
                    cardController.saveCard(card);
                    Get.back(result: true);
                    Get.snackbar(
                      'Success',
                      'Business card saved successfully!',
                      backgroundColor: Colors.green[100],
                      colorText: Colors.green[900],
                      snackPosition: SnackPosition.BOTTOM,
                      margin: EdgeInsets.all(20),
                      borderRadius: 10,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_alt, color: Colors.indigo[900], size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Save Business Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 