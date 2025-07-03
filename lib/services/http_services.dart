import 'dart:convert';
import 'package:film_app/features_book/book_responeces.dart';
import 'package:film_app/features_book/features_book.dart';
import 'package:film_app/features_book/features_page_info.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<BookResponse> fetchBooks(int newPage) async {
    List<Book> bookList = [];
    PageInfo? pageInfo;

    final url = Uri.parse(
      'https://api.freeapi.app/api/v1/public/books?page=$newPage&limit=10',
    );

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      for (var item in decoded["data"]["data"]) {
        bookList.add(Book.fromJson(item));
      }

      pageInfo = PageInfo.fromJson(decoded["data"]);
    } else {
      throw Exception("Veri alınamadı: ${response.statusCode}");
    }

    return BookResponse(books: bookList, pageInfo: pageInfo);
  }
}
