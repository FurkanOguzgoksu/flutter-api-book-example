import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_confirm.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:film_app/provider/provider_basket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PagePaymentTransaction extends StatefulWidget {
  final UserModel? personal;
  const PagePaymentTransaction({super.key, required this.personal});

  @override
  State<PagePaymentTransaction> createState() => _PagePaymentTransactionState();
}

class _PagePaymentTransactionState extends State<PagePaymentTransaction> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Set<String> savedAddress = {"Evim", "Ofisim", "Evim2"};
  String? selectedAdress;
  String? selectedPayment;
  bool showTextField = false;
  bool showCreditCard = false;
  bool isPaymentSuccess = false;
  int month = 1;
  int year = 2025;

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<BasketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.lock_outline),
            SizedBox(width: 5),
            Text("Güvenle Öde"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Teslimat Adresim",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add_home),
                            onPressed: () {
                              setState(() {
                                showTextField = !showTextField;
                              });
                            },
                          ),
                          const Text("Ekle"),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                      if (savedAddress.isEmpty) ...[
                        Center(
                          child: Text(
                            "Kayıtlı adres yok",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      if (savedAddress.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ...savedAddress.map(
                          (adress) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<String>(
                                    title: Text(adress),
                                    value: adress,
                                    groupValue: selectedAdress,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedAdress = value;
                                      });
                                    },
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      savedAddress.remove(adress);
                                      if (selectedAdress == adress) {
                                        selectedAdress = null;
                                      }
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Adres silindi"),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      if (showTextField)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  hintText: "Adresinizi girin",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (_addressController.text.trim().isNotEmpty &&
                                    savedAddress.contains(
                                          _addressController.text.toLowerCase(),
                                        ) ==
                                        false) {
                                  setState(() {
                                    savedAddress.add(
                                      _addressController.text.trim(),
                                    );
                                    showTextField = false;
                                    _addressController.clear();
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Adres kaydedildi"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Lütfen farklı adres girin!",
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Kaydet"),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: 30,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Ödeme Yöntemleri",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                      RadioListTile<String>(
                        title: const Text("Kredi Kartı"),
                        value: "Kredi Kartı",
                        groupValue: selectedPayment,
                        onChanged: (value) {
                          setState(() {
                            selectedPayment = value;
                          });
                        },
                      ),
                      if (selectedPayment == "Kredi Kartı")
                        Card(
                          margin: const EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Kredi Kartı Bilgileri",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: cardNoController,
                                    decoration: const InputDecoration(
                                      labelText: "Kart Numarası",
                                      prefixIcon: Icon(Icons.credit_card),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _cardNumberFormatter(),
                                    ],
                                    validator: (value) =>
                                        value == null ||
                                            value.isEmpty ||
                                            value.replaceAll(' ', '').length !=
                                                16
                                        ? "Kart numarası 16 haneli olmalı"
                                        : null,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<int>(
                                          decoration: const InputDecoration(
                                            labelText: "Ay",
                                            border: OutlineInputBorder(),
                                          ),
                                          value: month,
                                          items: List.generate(
                                            12,
                                            (index) => DropdownMenuItem(
                                              value: index + 1,
                                              child: Text("${index + 1}"),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              month = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: DropdownButtonFormField<int>(
                                          decoration: const InputDecoration(
                                            labelText: "Yıl",
                                            border: OutlineInputBorder(),
                                          ),
                                          value: year,
                                          items: List.generate(
                                            21,
                                            (index) => DropdownMenuItem(
                                              value: 2025 + index,
                                              child: Text("${2025 + index}"),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              year = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: cvvController,
                                    decoration: const InputDecoration(
                                      labelText: "CVV",
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "CVV boş bırakılamaz";
                                      } else if (value.length != 3) {
                                        return "CVV 3 haneli olmalı";
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      _threeDigitInputFormatter(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      RadioListTile<String>(
                        title: const Text("Kapıda Ödeme"),
                        value: "Kapıda Ödeme",
                        groupValue: selectedPayment,
                        onChanged: (value) {
                          setState(() {
                            selectedPayment = value;
                            showCreditCard = false;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Banka Havalesi"),
                        value: "Banka Havalesi",
                        groupValue: selectedPayment,
                        onChanged: (value) {
                          setState(() {
                            selectedPayment = value;
                            showCreditCard = false;
                          });
                        },
                      ),
                      if (selectedPayment == "Banka Havalesi") ...[
                        const SizedBox(height: 10),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Banka Hesapları (IBAN):",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                ...ibanList.map((bank) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bank["bankName"]!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                bank["iban"]!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.shopping_bag,
                            size: 30,
                            color: Colors.blue,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Teslim Edilecek Ürün/Ürünler",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                      if (basket.basketBooks.isEmpty)
                        const Text(
                          "Sepetiniz boş.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: basket.basketBooks.entries.map((entry) {
                            final book = entry.key;
                            final int count = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Text(
                                "- ${book.volumeInfo?.title}  ($count adet)",
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Ödenecek Toplam Ücret: ${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 2).format(basket.totalPrice)} ₺",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedAdress == null && selectedPayment == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Lütfen adres ve ödeme yöntemi seçin"),
                        ),
                      );
                      return;
                    } else if (selectedAdress == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Lütfen adres yöntemi seçin"),
                        ),
                      );
                      return;
                    } else if (selectedPayment == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Lütfen ödeme yöntemi seçin"),
                        ),
                      );
                      return;
                    }
                    if (showCreditCard && !_formKey.currentState!.validate()) {
                      return;
                    }

                    setState(() {
                      isPaymentSuccess = true;
                    });

                    if (mounted) {
                      if (isPaymentSuccess == true) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageConfirm(
                              personal: widget.personal,
                              paymetMethod: selectedPayment,
                              adress: selectedAdress,
                              success: isPaymentSuccess,
                            ),
                          ),
                          (route) => false,
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageConfirm(
                              personal: widget.personal,
                              paymetMethod: selectedPayment,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBackgroundColor,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Ödeme Yap"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _cardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Sadece rakamları al
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // En fazla 16 rakam olsun
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    // 4’erli gruplara ayır
    String newText = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) {
        newText += ' '; // her 4 karakterde bir boşluk
      }
      newText += digitsOnly[i];
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _threeDigitInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length < 4) {
      return newValue;
    }
    return oldValue;
  }
}

final List<Map<String, String>> ibanList = [
  {"bankName": "Ziraat Bankası", "iban": "TR11 1111 1111 1111 1111 1111 11"},
  {"bankName": "Kuveyt Türk", "iban": "TR22 2222 2222 2222 2222 2222 22"},
  {"bankName": "Vakıfbank", "iban": "TR33 3333 3333 3333 3333 3333 33"},
];
