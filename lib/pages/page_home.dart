import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
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
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkConnection(); // Başlangıçta kontrol et
    _loadData(); // Sayfa yüklenirken veri çek
    bookFuture = _getBooks();

    // Connectivity() ➜ Flutter’ın bağlantı izleme sınıfı (bir nevi trafik polisi).
    // onConnectivityChanged ➜ Bağlantı durumunu dinleyen akış (stream).
    // listen((_) { ... }) ➜ Her değişiklikte bir şey yap demek.
    // _checkConnection() ➜ Bu fonksiyonu her seferinde çağır (bağlantı hâlâ var mı diye bak).

    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      await _checkConnection();

      if (_isConnected) {
        setState(() {
          bookFuture = _getBooks();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // İnternet dinleyiciyi iptal et
    searchContreller.dispose();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(Duration(seconds: 3)); // max 3 saniye bekle
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
    } on TimeoutException {
      _handleNoConnection();
    } on SocketException {
      _handleNoConnection();
    }
  }

  void _handleNoConnection() {
    if (_isConnected) {
      setState(() {
        _isConnected = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bağlantı kesildi')));
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
      return [];
    }

    try {
      var values = await HttpService.fetchBooks(
        currentPage,
      ).timeout(Duration(seconds: 5));

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchContreller,
              decoration: InputDecoration(
                hintText: "Kitap ara...",
                hintStyle: TextStyle(color: kBlackColor),
                prefixIcon: Icon(Icons.search),
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
        ),
      ),
      drawer: DrawerMenu(personal: widget.personal),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FirstBanner(isConnected: _isConnected, personal: widget.personal),
              CarouselSlider.builder(
                itemCount: allBooks.length >= 10 ? 10 : allBooks.length,
                itemBuilder: (context, index, realIndex) {
                  final book = allBooks[index];
                  final title = book.volumeInfo?.title ?? "Kitap Adı";
                  final authors =
                      book.volumeInfo?.authors?.join(", ") ?? "Yazar Bilgisi";
                  final imageUrl =
                      book.volumeInfo?.imageLinks?.thumbnail ??
                      "Resim bulunmadı ";
                  final price = "${book.price ?? 1.00}₺";

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageBook(fetchedBook: book),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 165,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Container(
                                      width: 80,
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "images/book.png",
                                      width: 80,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  authors,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "$price ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  allBooks.length >= 10 ? 10 : allBooks.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: CircleAvatar(
                        backgroundColor: currentIndex == index
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),

              if (_isConnected == true) ...[
                Container(
                  height: 120,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bookCategories.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              border: Border.all(width: 2),
                            ),
                            child: Icon(
                              bookCategories[index]['icon'],
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            bookCategories[index]['title'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              FutureBuilder<List<Book>>(
                future: bookFuture,
                builder: (context, snapshot) {
                  if (!_isConnected) {
                    return Center(
                      child: Text(
                        "İnternet bağlantısı yok",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    );
                  }

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
                            "İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                                favorite.toggleBookFavorite(book);
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
            ],
          ),
        ),
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
