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
    final String title = book.volumeInfo?.title ?? "Başlık yok";
    final String authors = book.volumeInfo?.authors?.join("-") ?? "";
    final double price = book.price ?? kBookPrice;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
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

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          basketProvider.removeBook(book);
                        },
                      ),
                      Text("Sil"),
                      const SizedBox(width: 100),
                      Text(
                        "$price ₺",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
