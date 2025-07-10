import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:film_app/features_book/features_book.dart';
import 'package:film_app/features_book/features_page_info.dart';
import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_book_detail.dart';
import 'package:film_app/pages/page_favorite.dart';
import 'package:film_app/pages/page_shopping_basket.dart';
import 'package:film_app/pages/user_operations/page_log_in.dart';
import 'package:film_app/services/http_services.dart';
import 'package:film_app/provider/provider_favorite.dart';
import 'package:film_app/widgets/card_grid.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:film_app/widgets/drawer_menu.dart';
import 'package:film_app/widgets/first_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageHome extends StatefulWidget {
  final UserModel? personal;

  const PageHome({super.key, this.personal});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  // Arama kutusu kontrolü
  TextEditingController searchContreller = TextEditingController();
  //İnternet bağlantısı değişimlerini dinlemek için
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Future<List<Book>>? bookFuture;
  List<Book> allBooks = [];
  List<Book> filteredBooks = [];
  PageInfo? pageInfo;
  bool _isConnected = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _checkConnection(); // İnternet var mı yok mu kontrol eder
    _loadData(); // Sayfalama için veri hazırlar
    bookFuture = _getBooks();
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkConnection();
    });

    // Connectivity() ➜ Flutter’ın bağlantı izleme sınıfı (bir nevi trafik polisi).
    // onConnectivityChanged ➜ Bağlantı durumunu dinleyen akış (stream).
    // listen((_) { ... }) ➜ Her değişiklikte bir şey yap demek.
    // _checkConnection() ➜ Bu fonksiyonu her seferinde çağır (bağlantı hâlâ var mı diye bak).
  }

  @override
  void dispose() {
    _subscription?.cancel(); // İnternet dinleyiciyi iptal et
    searchContreller.dispose();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      bool connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (mounted && connected != _isConnected) {
        setState(() {
          _isConnected = connected;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              connected ? 'Bağlantı yeniden kuruldu' : 'Bağlantı kesildi',
            ),
          ),
        );
      }
    } catch (_) {
      if (_isConnected) {
        setState(() {
          _isConnected = false;
        });

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bağlantı kesildi')));
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      bookFuture = _getBooks();
      currentPage = pageInfo?.page ?? 1;
    });
  }

  Future<List<Book>> _getBooks() async {
    await _checkConnection();

    if (!_isConnected) {
      throw Exception("İnternet bağlantısı yok");
    }

    try {
      var values = await HttpService.fetchBooks(currentPage);
      setState(() {
        pageInfo = values.pageInfo;
        allBooks = values.books;
        filteredBooks = values.books;
      });
      return values.books;
    } catch (e) {
      throw Exception("Veri alınamadı: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorite = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text("AnaSayfa"),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.person, color: kTextWhiteColor),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.favorite),
                    const SizedBox(width: 15),
                    Text("Favorilerim"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_checkout),
                    const SizedBox(width: 15),
                    Text("Sepetim"),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageFavorite()),
                );
              } else if (value == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PageShoppingBasket(personal: widget.personal),
                  ),
                );
              }
            },
          ),
          IconButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogInPage()),
              );
            },
            icon: Icon(Icons.logout, color: kTextWhiteColor),
          ),
        ],
      ),
      drawer: DrawerMenu(personal: widget.personal),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchContreller,
              decoration: InputDecoration(
                hintText: "Kitap ara..",
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (input) {
                setState(() {
                  filteredBooks = allBooks.where((book) {
                    final title = book.volumeInfo?.title?.toLowerCase() ?? '';
                    final subTitle =
                        book.volumeInfo?.subTitle?.toLowerCase() ?? '';
                    final query = input.toLowerCase();

                    return title.contains(query) || subTitle.contains(query);
                  }).toList();
                });
              },
            ),
          ),

          FirstBanner(isConnected: _isConnected, personal: widget.personal),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: bookFuture,
              builder: (context, snapshot) {
                // ConnectionState bir enum'dur ve bu Future’ın veya Stream’in şu anda hangi durumda olduğunu belirtir.
                // waiting -> hala veri gelmedi bekliyoruz...
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          snapshot.error.toString().contains(
                                "Failed host lookup",
                              )
                              ? "İnternet bağlantısı yok"
                              : "Bir hata oluştu: ${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              bookFuture = _getBooks();
                            });
                          },
                          child: const Text("Yeniden Dene"),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  var orientation = MediaQuery.of(context).orientation;

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: orientation == Orientation.portrait
                          ? 2
                          : 3,
                      childAspectRatio: 0.45,
                    ),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      var book = filteredBooks[index];
                      return Center(
                        child: CardGridBook(
                          fetchedbook: book,
                          fClick: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PageBook(fetchedBook: book),
                              ),
                            );
                          },
                          isFavorited: favorite.isFavorite(book),
                          onFavorite: () {
                            setState(() {
                              if (favorite.favoriteBooks.contains(book)) {
                                favorite.toggleBookFavorite(book);
                              } else {
                                favorite.toggleBookFavorite(book);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Bir hata oluştu...'));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: kBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: pageInfo?.previousPage == true
                  ? () {
                      setState(() {
                        currentPage--;
                        bookFuture = _getBooks();
                      });
                    }
                  : null,
              icon: Icon(
                Icons.arrow_left_outlined,
                color: pageInfo?.previousPage == true
                    ? kBlackColor
                    : kTextWhiteColor,
              ),
            ),
            Text("${pageInfo?.page} / ${pageInfo?.totalPages} "),
            DropdownButton<int>(
              value: currentPage,
              // Toplam sayfa sayısı kadar <DropdownMenuItem> oluşturuluyor.
              items: List.generate(
                pageInfo?.totalPages ?? 0,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text("${index + 1}"),
                ),
              ),
              onChanged: (int? newPage) {
                setState(() {
                  if (currentPage != newPage) {
                    currentPage = newPage!;
                    bookFuture = _getBooks();
                  }
                });
              },
            ),
            IconButton(
              onPressed: pageInfo?.nextPage == true
                  ? () {
                      setState(() {
                        currentPage++;
                        bookFuture = _getBooks();
                      });
                    }
                  : null,
              icon: Icon(
                Icons.arrow_right_outlined,
                color: pageInfo?.nextPage == true
                    ? kBlackColor
                    : kTextWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
