import 'package:film_app/features_book/features_book.dart';
import 'package:film_app/provider/provider_basket.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class PageBook extends StatefulWidget {
  final Book fetchedBook;
  const PageBook({super.key, required this.fetchedBook});

  @override
  State<PageBook> createState() => _PageBookState();
}

class _PageBookState extends State<PageBook> {
  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<BasketProvider>(context);
    final bool isInBasket = basket.basketBooks.containsKey(widget.fetchedBook);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(widget.fetchedBook.volumeInfo!.title ?? "None"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      widget.fetchedBook.volumeInfo!.imageLinks?.thumbnail ??
                          "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('images/book.png');
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Text(
                      widget.fetchedBook.volumeInfo?.title ?? "",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.remove_red_eye_sharp),

                            onPressed: () {
                              final previewLink =
                                  widget.fetchedBook.volumeInfo?.previewLink;

                              if (previewLink != null &&
                                  previewLink.isNotEmpty) {
                                launchUrl(Uri.parse(previewLink));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Önizleme linki mevcut değil.",
                                    ),
                                  ),
                                );
                              }
                            },
                            label: Text(
                              "Önizleme",
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.shopping_cart),

                            onPressed: () {
                              final buyLink =
                                  widget.fetchedBook.volumeInfo?.infoLink;

                              if (buyLink != null && buyLink.isNotEmpty) {
                                launchUrl(Uri.parse(buyLink));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Satın alma linki mevcut değil.",
                                    ),
                                  ),
                                );
                              }
                            },
                            label: Text(
                              "Satın al",
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.black, thickness: 1.5),
              Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(), // Sol sütun genişliği kadar yer kaplasın
                  1: FlexColumnWidth(), // Sağ sütun kalan alanı alsın
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  _buildTableRow(
                    "Kitap Adı:",
                    widget.fetchedBook.volumeInfo?.title ?? "Yok",
                  ),
                  _buildTableRow(
                    "Yayın Tarihi:",
                    widget.fetchedBook.volumeInfo?.publishedDate ??
                        "Bilinmiyor",
                  ),
                  _buildTableRow(
                    "Sayfa Sayısı:",
                    "${widget.fetchedBook.volumeInfo?.pageCount ?? 0}",
                  ),
                  _buildTableRow(
                    "Yazar(lar):",
                    widget.fetchedBook.volumeInfo?.authors?.join("-") ??
                        "Bilinmiyor",
                  ),
                  _buildTableRow(
                    "ISBN Bilgileri:",
                    widget.fetchedBook.volumeInfo?.industryIdentifiers
                            ?.map((e) => "${e.type} - ${e.identifier}")
                            .join("\n") ??
                        "Bilinmiyor",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Açıklama: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(color: Colors.black, thickness: 1.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        widget.fetchedBook.volumeInfo?.description ??
                            "Açıklama bulunmadı",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                "${widget.fetchedBook.price ?? kBookPrice} ₺",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: isInBasket
                      ? null
                      : () {
                          basket.addBook(widget.fetchedBook);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Sepete başarıyla eklendi"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                  child: const Text(
                    "Sepete Ekle",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TableRow _buildTableRow(String label, String value) {
  return TableRow(
    children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.top,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(padding: const EdgeInsets.all(8.0), child: Text(value)),
    ],
  );
}
