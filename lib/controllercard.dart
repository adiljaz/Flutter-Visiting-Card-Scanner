import 'package:get/get.dart';
import 'package:zikrabyte/visitingcard.dart';
import 'package:zikrabyte/storage.dart';

class CardController extends GetxController {
  final StorageService _storageService = StorageService();
  final RxList<VisitingCard> cards = <VisitingCard>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCards();
  }

  void loadCards() async {
    try {
      isLoading.value = true;
      cards.value = await _storageService.getCards();
    } catch (e) {
      print('Error loading cards: $e');
      Get.snackbar('Error', 'Failed to load cards. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void saveCard(VisitingCard card) async {
    try {
      await _storageService.saveCard(card);
      cards.add(card);
    } catch (e) {
      print('Error saving card: $e');
      Get.snackbar('Error', 'Failed to save card. Please try again.');
    }
  }
}