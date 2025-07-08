import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_payment_transaction.dart';
import 'package:film_app/provider/provider_basket.dart';
import 'package:film_app/widgets/card_list.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PageShoppingBasket extends StatefulWidget {
  final UserModel? personal;
  const PageShoppingBasket({super.key, this.personal});

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
            const Text("Sepetim"),
            const Spacer(),
            Text(
              "Ürün sayısı: ${basket.totalItems}",
              style: const TextStyle(fontSize: 17),
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
              height: 80,
              color: kBackgroundColor,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Toplam Tutar ",
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              "${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 2).format(basket.totalPrice)} ₺",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 70),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Ödeme işlemlerine yönlendiriliyorsunuz",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PagePaymentTransaction(
                              personal: widget.personal,
                            ),
                          ),
                        );
                      },
                      child: const Text("Alışverişi Tamamla"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
