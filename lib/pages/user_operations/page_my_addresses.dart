import 'package:film_app/pages/page_home.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:flutter/material.dart';

class PageMyAddresses extends StatefulWidget {
  const PageMyAddresses({super.key});

  @override
  State<PageMyAddresses> createState() => _PageMyAddressesState();
}

final List<Map<String, String>> myAddres = [
  {
    "title": "Evim",
    "addres": "Beyhekim Mah. Beyhekim Cad No:5, Selçuklu / Konya",
  },
  {"title": "İş", "addres": "Aziziye, Mevlana Cad. Karatay/Konya"},
  {"title": 'Aile', "addres": "Yenişehir, Fikir Sok Cad. No:34, Meram/Konya"},
];

class _PageMyAddressesState extends State<PageMyAddresses> {
  final TextEditingController _addressTitleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool showAddresAdd = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PageHome()),
              ); // Ana sayfanın route’u
            }
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        backgroundColor: kBackgroundColor,
        title: const Text("Adreslerim"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  showAddresAdd = !showAddresAdd;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(10),
              ),
              child: const Text("Adres Ekle"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (showAddresAdd)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _addressTitleController,
                        decoration: const InputDecoration(
                          hintText: "Adres Başlığı (Evim, Ofisim)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          hintText: "Adresinizi girin (Mah/Sok/No/Semt)",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_addressTitleController.text.trim().isEmpty ||
                              _addressController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Başlık ve adres girin!"),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            myAddres.add({
                              "title": _addressTitleController.text.trim(),
                              "addres": _addressController.text.trim(),
                            });
                            showAddresAdd = false;
                            _addressTitleController.clear();
                            _addressController.clear();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Adres kaydedildi")),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBackgroundColor,
                        ),
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: kBlackColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: myAddres.isEmpty
                  ? const Center(child: Text("Henüz adres eklenmedi"))
                  : ListView.builder(
                      itemCount: myAddres.length,
                      itemBuilder: (context, index) {
                        final addres = myAddres[index];
                        return Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(addres["title"] ?? "Başlıksız"),
                                  subtitle: Text(
                                    addres["addres"] ?? "Adres bilgisi yok",
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    myAddres.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Adres silindi"),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
