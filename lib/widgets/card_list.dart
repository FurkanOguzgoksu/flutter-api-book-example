import 'package:film_app/provider/provider_favorite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:film_app/provider/provider_basket.dart';
import 'package:film_app/features_book/features_book.dart';

class CardListBook extends StatelessWidget {
  final Book book;
  const CardListBook({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final basketProvider = Provider.of<BasketProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final String title = book.volumeInfo?.title ?? "Başlık yok";
    final String authors = book.volumeInfo?.authors?.join("-") ?? "";
    final double price = book.price ?? kBookPrice;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: (book.volumeInfo?.imageLinks?.thumbnail != null)
                      ? NetworkImage(book.volumeInfo!.imageLinks!.thumbnail!)
                      : const AssetImage('images/book.png') as ImageProvider,

                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              !favoriteProvider.isFavorite(book)
                                  ? "Favorilere Ekle"
                                  : "Favorilerden Çıkar",
                              style: TextStyle(
                                color: !favoriteProvider.isFavorite(book)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(
                              "Sil",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 1) {
                            favoriteProvider.toggleBookFavorite(book);
                          } else if (value == 2) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Sil",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(
                                    "Ürünü silmek istediğinize emin misiniz?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Hayır"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        basketProvider.removeBook(book);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Evet"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    authors,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (basketProvider.getBookCount(book) == 1) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Sil",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  content: Text(
                                    "Ürünü silmek istediğinize emin misiniz?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Hayır"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        basketProvider.removeBook(book);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Evet"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            basketProvider.decrementBookCount(book);
                          }
                        },
                        icon: const Icon(Icons.remove, size: 20),
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "${basketProvider.getBookCount(book)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          basketProvider.incrementBookCount(book);
                        },
                        icon: const Icon(Icons.add, size: 20),
                      ),
                      Text(
                        "${price.toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
