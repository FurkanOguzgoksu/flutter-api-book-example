import 'package:flutter/material.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:film_app/features_book/features_book.dart';

class BasketProvider with ChangeNotifier {
  //Flutter'da ChangeNotifier, bir "dinleme (listener) ve haber verme (notify)" sistemidir.
  //Bu sınıf, veride bir değişiklik olduğunda, bu değişikliği kullanan (dinleyen)
  //tüm widget'lara “veri değişti!” sinyali gönderir. Böylece UI otomatik güncellenir.

  final Map<Book, int> _basketBooks = {};

  Map<Book, int> get basketBooks => _basketBooks;

  void addBook(Book book) {
    if (basketBooks.containsKey(book)) {
      _basketBooks[book] = _basketBooks[book]! + 1;
    } else {
      _basketBooks[book] = 1;
    }

    notifyListeners(); // Tüm dinleyicileri uyar, arayüz güncellensin
    // with ile aldım
  }

  void removeBook(Book book) {
    _basketBooks.remove(book);
    notifyListeners(); // Tüm dinleyicileri uyar, arayüz güncellensin
  }

  double get totalPrice => _basketBooks.entries.fold(
    0,
    (sum, entry) => sum + ((entry.key.price ?? kBookPrice) * entry.value),
  );

  void incrementBookCount(Book book) {
    if (_basketBooks.containsKey(book) && _basketBooks[book]! < 10) {
      _basketBooks[book] = _basketBooks[book]! + 1;

      notifyListeners();
    }
  }

  void decrementBookCount(Book book) {
    if (_basketBooks.containsKey(book) && _basketBooks[book]! > 1) {
      _basketBooks[book] = _basketBooks[book]! - 1;
    } else {
      _basketBooks.remove(book);
    }
    notifyListeners();
  }

  int getBookCount(Book book) {
    return _basketBooks[book] ?? 0;
  }
}
