import 'package:flutter/material.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:film_app/features_book/features_book.dart';

class BasketProvider with ChangeNotifier {
  //Flutter'da ChangeNotifier, bir "dinleme (listener) ve haber verme (notify)" sistemidir.
  //Bu sınıf, veride bir değişiklik olduğunda, bu değişikliği kullanan (dinleyen)
  //tüm widget'lara “veri değişti!” sinyali gönderir. Böylece UI otomatik güncellenir.

  final List<Book> _basketBooks = [];

  List<Book> get basketBooks => _basketBooks;

  void addBook(Book book) {
    _basketBooks.add(book);
    notifyListeners(); // Tüm dinleyicileri uyar, arayüz güncellensin
    // with ile aldım
  }

  void removeBook(Book book) {
    _basketBooks.remove(book);
    notifyListeners(); // Tüm dinleyicileri uyar, arayüz güncellensin
  }

  double get totalPrice =>
      _basketBooks.fold(0, (sum, book) => sum + (book.price ?? kBookPrice));
}
