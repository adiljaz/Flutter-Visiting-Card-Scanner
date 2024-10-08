

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zikrabyte/visitingcard.dart';

class StorageService {
  static const String CARDS_KEY = 'visiting_cards';

  Future<List<VisitingCard>> getCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString(CARDS_KEY);
    if (cardsJson != null) {
      final List<dynamic> decodedJson = json.decode(cardsJson);
      return decodedJson.map((item) => VisitingCard.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveCard(VisitingCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final List<VisitingCard> cards = await getCards();
    cards.add(card);
    final String encodedJson = json.encode(cards.map((e) => e.toJson()).toList());
    await prefs.setString(CARDS_KEY, encodedJson);
  }

  Future<void> deleteCard(VisitingCard card) async {
    final prefs = await SharedPreferences.getInstance();
    final List<VisitingCard> cards = await getCards();
    cards.removeWhere((c) => 
      c.name == card.name && 
      c.phoneNumber == card.phoneNumber && 
      c.email == card.email && 
      c.company == card.company
    );
    final String encodedJson = json.encode(cards.map((e) => e.toJson()).toList());
    await prefs.setString(CARDS_KEY, encodedJson);
  }

  Future<void> updateCard(VisitingCard oldCard, VisitingCard newCard) async {
    final prefs = await SharedPreferences.getInstance();
    final List<VisitingCard> cards = await getCards();
    final index = cards.indexWhere((c) => 
      c.name == oldCard.name && 
      c.phoneNumber == oldCard.phoneNumber && 
      c.email == oldCard.email && 
      c.company == oldCard.company
    );
    if (index != -1) {
      cards[index] = newCard;
      final String encodedJson = json.encode(cards.map((e) => e.toJson()).toList());
      await prefs.setString(CARDS_KEY, encodedJson);
    }
  }

  Future<void> clearAllCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(CARDS_KEY);
  }
}