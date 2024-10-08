import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikrabyte/imagecontroller.dart';
import 'package:zikrabyte/result.dart';


class ScanPage extends StatelessWidget {
  final ImageController imageController = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Card', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor, Colors.indigo[800]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  String result = await imageController.captureImage();
                  if (result.isNotEmpty) {
                    Get.to(() => ResultPage(extractedText: result));
                  }
                },
                icon: Icon(Icons.camera_alt, size: 30),
                label: Text('Capture Image', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  iconColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  String result = await imageController.selectImage();
                  if (result.isNotEmpty) {
                    Get.to(() => ResultPage(extractedText: result));
                  }
                },
                icon: Icon(Icons.photo_library, size: 30),
                label: Text('Select Image', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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