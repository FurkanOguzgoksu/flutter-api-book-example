import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:film_app/widgets/constant.dart';

class PageForgotPassword extends StatefulWidget {
  const PageForgotPassword({super.key});

  @override
  State<PageForgotPassword> createState() => _PageForgotPasswordState();
}

class _PageForgotPasswordState extends State<PageForgotPassword> {
  final TextEditingController _eMailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  bool _isButon = false;

  static Future<int> _forgotPasswordServices(String email) async {
    final Uri url = Uri.parse(kUserForgotPasswordLink);
    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode({"email": email}),
    );

    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Color(0xFF1E88E5)),
                  ),
                  const Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.security, color: Color(0xFF1E88E5)),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Text(
                    "Sorun değil!\nOkumaya devam etmek için e-posta adresini girmen yeterli.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Expanded, içindeki widget’ın mümkün olan tüm boş alanı kaplamasını sağlar.
              // Flexible da boş alanı kullanır ama gerekirse sıkışabilir, yani “gerektiği kadar yer kapla” der.
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _eMailController,
                                enabled: !_isLoading,

                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  labelText:
                                      "Lütfen E-posta adresinizi giriniz",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "E-posta boş bırakılamaz";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  onPressed: _isButon
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() => _isButon = true);

                                            int resultCode =
                                                await _forgotPasswordServices(
                                                  _eMailController.text.trim(),
                                                );

                                            Future.delayed(
                                              const Duration(seconds: 5),
                                              () {
                                                if (mounted) {
                                                  setState(() {
                                                    _isButon = false;
                                                  });
                                                }
                                              },
                                            );

                                            if (resultCode == 200) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                  content: Text(
                                                    "Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.",
                                                  ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                  content: Text(
                                                    "Hata: $resultCode",
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E88E5),

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Gönder",
                                    style: TextStyle(color: kTextWhiteColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
