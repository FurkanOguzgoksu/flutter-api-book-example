import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_confirm.dart';
import 'package:film_app/pages/user_operations/page_my_addresses.dart';
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
  final TextEditingController cardNoController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> savedAddress = [];
  String? selectedAddress;
  String? selectedPayment;
  int year = DateTime.now().year;
  int month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    savedAddress = myAddres;
  }

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<BasketProvider>(context);
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

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
              _buildAddressCard(context),
              _buildPaymentMethodCard(context, currentYear, currentMonth),
              _buildBasketItemsCard(basket),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: kBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Toplam Tutar", style: TextStyle(fontSize: 14)),
                  Text(
                    "${NumberFormat.currency(locale: 'tr_TR', symbol: '', decimalDigits: 2).format(basket.totalPrice)} ₺",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if ((selectedPayment?.isEmpty ?? true) &&
                      (selectedAddress?.isEmpty ?? true)) {
                    _showSnack(
                      "Lütfen adres ve ödeme yöntemi seçiniz",
                      Colors.red,
                    );
                    return;
                  } else if ((selectedPayment?.isEmpty ?? true)) {
                    _showSnack("Lütfen ödeme yöntemi seçiniz", Colors.red);
                    return;
                  } else if ((selectedAddress?.isEmpty ?? true)) {
                    _showSnack("Lütfen adres yöntemi seçiniz", Colors.red);
                    return;
                  }
                  if (selectedPayment == "Kredi Kartı" &&
                      _formKey.currentState != null &&
                      !_formKey.currentState!.validate()) {
                    return;
                  }
                  if (year == currentYear && month < currentMonth) {
                    _showSnack("Geçmiş bir tarih seçilemez!", Colors.red);
                    return;
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageConfirm(
                        personal: widget.personal,
                        paymetMethod: selectedPayment,
                        adress: selectedAddress,
                        success: true,
                      ),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: kBlackColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text("Ödeme Yap"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 30, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  "Teslimat Adresim",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (savedAddress.isEmpty) {
                      _showSnack("Kayıtlı adres bulunamadı.", Colors.red);
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            const Text("Kayıtlı Adreslerim"),
                            const Spacer(),
                            GestureDetector(
                              onLongPress: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Adres Ekle"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: IconButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PageMyAddresses(),
                                    ),
                                  );
                                  setState(() {
                                    _checkSelectedAddressValidity();
                                  });
                                },
                                icon: const Icon(Icons.add_home_work),
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: myAddres.map((address) {
                            return RadioListTile<String>(
                              title: Text(address["title"]!),
                              subtitle: Text(address["addres"]!),
                              value: address["addres"]!,
                              groupValue: selectedAddress,
                              onChanged: (value) {
                                setState(() {
                                  selectedAddress = value;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBackgroundColor,
                    foregroundColor: kBlackColor,
                  ),
                  child: const Text("Adres Seç"),
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            Text(
              selectedAddress ?? "Lütfen adres seçiniz!",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    int currentYear,
    int currentMonth,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.attach_money, size: 30, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  "Ödeme Yöntemleri",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(thickness: 1.5),
            RadioListTile<String>(
              title: const Text("Kredi Kartı"),
              value: "Kredi Kartı",
              groupValue: selectedPayment,
              onChanged: (value) => setState(() => selectedPayment = value),
            ),
            if (selectedPayment == "Kredi Kartı")
              Card(
                margin: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCardInfoTextField(
                          controller: cardNoController,
                          label: "Kart Numarası",
                          prefixIcon: Icons.credit_card,
                          validator: (value) {
                            String cleaned = value!.replaceAll(' ', '');
                            if (cleaned.length != 16) {
                              return "Kart numarası 16 haneli olmalı";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _CardNumberFormatter(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMonthDropdown(
                                currentYear,
                                currentMonth,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildYearDropdown(
                                currentYear,
                                currentMonth,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildCardInfoTextField(
                          controller: cvvController,
                          label: "CVV",
                          prefixIcon: Icons.lock,
                          validator: (value) {
                            if (value!.length != 3) {
                              return "CVV 3 haneli olmalı";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _ThreeDigitInputFormatter(),
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
              onChanged: (value) => setState(() => selectedPayment = value),
            ),
            RadioListTile<String>(
              title: const Text("Banka Havalesi"),
              value: "Banka Havalesi",
              groupValue: selectedPayment,
              onChanged: (value) => setState(() => selectedPayment = value),
            ),
            if (selectedPayment == "Banka Havalesi") ...[
              Card(
                margin: const EdgeInsets.only(top: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ibanList.map((bank) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                _showSnack(
                                  "IBAN kopyalandı!",
                                  Colors.indigoAccent,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBasketItemsCard(BasketProvider basket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.shopping_bag, size: 30, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Teslim Edilecek Ürünler",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              ...basket.basketBooks.entries.map((entry) {
                final book = entry.key;
                final count = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "- ${book.volumeInfo?.title} ($count adet)",
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  void _checkSelectedAddressValidity() {
    if (!myAddres.any((address) => address['addres'] == selectedAddress)) {
      selectedAddress = null;
    }
  }

  void _showSnack(String msg, Color clr) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: clr,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildCardInfoTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters,
    );
  }

  Widget _buildMonthDropdown(int currentYear, int currentMonth) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: "Ay",
        border: OutlineInputBorder(),
      ),
      value: month,
      items: List.generate(12, (index) {
        int monthValue = index + 1;
        bool isDisabled = (year == currentYear && monthValue < currentMonth);
        return DropdownMenuItem<int>(
          value: isDisabled ? null : monthValue,
          enabled: !isDisabled,
          child: Text(
            "${monthValue.toString().padLeft(2, '0')} ", // Sayıların başına sıfır ekleme
            style: TextStyle(color: isDisabled ? Colors.grey : Colors.black),
          ),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            month = value;
          });
        }
      },
    );
  }

  Widget _buildYearDropdown(int currentYear, int currentMonth) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: "Yıl",
        border: OutlineInputBorder(),
      ),
      value: year,
      items: List.generate(
        21,
        (index) => DropdownMenuItem(
          value: currentYear + index,
          child: Text("${currentYear + index}"),
        ),
      ),
      onChanged: (value) {
        setState(() {
          year = value!;
          if (year == currentYear && month < currentMonth) {
            _showSnack("Geçmiş bir ay seçilemez!", Colors.red);
            month = currentMonth;
          }
        });
      },
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > 16) digitsOnly = digitsOnly.substring(0, 16);
    String newText = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) newText += ' ';
      newText += digitsOnly[i];
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class _ThreeDigitInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length <= 3) {
      return newValue;
    }
    return oldValue;
  }
}
