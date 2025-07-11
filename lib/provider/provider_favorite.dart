import 'package:film_app/features_book/features_book.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Book> _favoriteBooks = [];

  List<Book> get favoriteBooks => _favoriteBooks;

  void toggleBookFavorite(Book book) {
    if (_favoriteBooks.contains(book)) {
      _favoriteBooks.remove(book);
    } else {
      _favoriteBooks.add(book);
    }
    notifyListeners(); // Tüm dinleyicileri uyar, arayüz güncellensin
  }

  bool isFavorite(Book book) {
    return _favoriteBooks.contains(book);
  }

  int getDifferentFavoriteValues() {
    List<Book> differentBasketList = [];

    for (var item in favoriteBooks) {
      if (_favoriteBooks.contains(item)) {
        differentBasketList.add(item);
      }
    }
    return differentBasketList.length;
  }
}
