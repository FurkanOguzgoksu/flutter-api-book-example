import 'package:flutter/material.dart';
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

  void deleteBookList() {
    _basketBooks.clear();
    notifyListeners();
  }

  double get totalPrice {
    double totalSum = 0;

    for (var entry in _basketBooks.entries) {
      totalSum += (entry.key.price ?? 1.00) * entry.value;
    }
    return totalSum;
  }

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

  int get totalItems {
    int sum = 0;

    for (var value in _basketBooks.values) {
      sum += value;
    }

    return sum;
  }
}
