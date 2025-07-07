import 'package:film_app/provider/provider_basket.dart';
import 'package:film_app/widgets/card_list.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageShoppingBasket extends StatefulWidget {
  const PageShoppingBasket({super.key});

  @override
  State<PageShoppingBasket> createState() => _PageShoppingBasketState();
}

class _PageShoppingBasketState extends State<PageShoppingBasket> {
  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<BasketProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Row(
          children: [
            Text("Sepetim"),
            const Spacer(),
            Text(
              "Ürün sayısı: ${basket.totalItems}",
              style: TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
      body: basket.basketBooks.isEmpty
          ? const Center(child: Text("Sepetinizde kitap yok."))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: basket.basketBooks.length,
              itemBuilder: (context, index) {
                var book = basket.basketBooks.keys.toList()[index];
                return CardListBook(book: book);
              },
            ),
      bottomNavigationBar: basket.basketBooks.isEmpty
          ? null
          : Container(
              height: 60,
              color: kBackgroundColor,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "Toplam Tutar: ${basket.totalPrice.toStringAsFixed(2)} ₺",

                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Ödemeye yönlendiriliyorsunuz"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text("Ödeme Yap"),
                  ),
                ],
              ),
            ),
    );
  }
}
