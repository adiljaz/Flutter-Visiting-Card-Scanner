import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zikrabyte/controllercard.dart';
import 'package:zikrabyte/carddetails.dart';
import 'package:zikrabyte/scan.dart';

class HomePage extends StatelessWidget {
  final CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VisiScan Pro', style: TextStyle(fontWeight: FontWeight.bold)),
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
        child: Obx(() {
          if (cardController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (cardController.cards.isEmpty) {
            return Center(
              child: Text(
                'No cards yet. Tap + to scan!',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: cardController.cards.length,
              itemBuilder: (context, index) {
                final card = cardController.cards[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.amberAccent,
                        child: Text(
                          card.name.isNotEmpty ? card.name[0].toUpperCase() : '',
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                      title: Text(card.name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(card.company),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.indigo),
                      onTap: () => Get.to(() => CardDetailPage(card: card)),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => ScanPage()),
        icon: Icon(Icons.add_a_photo),
        label: Text('Scan'),
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.indigo,
      ),
    );
  }
} 