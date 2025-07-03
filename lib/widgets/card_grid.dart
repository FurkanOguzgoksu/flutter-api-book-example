import 'package:film_app/features_book/features_book.dart';
import 'package:film_app/provider/provider_basket.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CardGridBook extends StatelessWidget {
  final Book fetchedbook;
  final VoidCallback fClick;
  final bool isFavorited;
  final VoidCallback onFavorite;

  const CardGridBook({
    super.key,
    required this.fetchedbook,
    required this.fClick,
    required this.isFavorited,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<BasketProvider>(context);
    final bool isInBasket = basket.basketBooks.contains(fetchedbook);

    final String imageLinks =
        fetchedbook.volumeInfo?.imageLinks?.thumbnail ?? "";
    final String title = fetchedbook.volumeInfo?.title ?? "Başlık yok";
    final String subHead = fetchedbook.volumeInfo?.authors?.join("-") ?? "";
    final double price = fetchedbook.price ?? kBookPrice;

    // Karta tıklama özelliği veriyor
    return InkWell(
      onTap: fClick,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 150,
                  width: double.infinity, // Bulunduğu sınırda yayılıyor.
                  child: Image.network(
                    imageLinks,
                    fit: BoxFit.cover, // Boşluk bırakmaz
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('images/book.png', fit: BoxFit.cover);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Center(child: Text(subHead, textAlign: TextAlign.center)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "$price ₺",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isInBasket
                        ? null
                        : () {
                            basket.addBook(fetchedbook);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInBasket
                          ? Colors.grey
                          : kBackgroundColor,
                    ),
                    child: Text(
                      isInBasket ? "Sepette" : "Sepete Ekle",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavorite,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
