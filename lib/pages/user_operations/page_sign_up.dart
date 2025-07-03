import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:film_app/widgets/constant.dart';

class PageSignUp extends StatefulWidget {
  const PageSignUp({super.key});

  @override
  State<PageSignUp> createState() => _PageSignUpState();
}

class _PageSignUpState extends State<PageSignUp> {
  static Future<Map<String, dynamic>> _signUpServices({
    String? email,
    String? username,
    String? password,
    String? role,
  }) async {
    final Uri url = Uri.parse(kUserRegisterLink);
    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "email": email,
        "role": role ?? "ADMIN",
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 && data["data"] != null) {
      return {"statusCode": 201, "userData": data["data"]};
    } else {
      return {
        "statusCode": response.statusCode,
        "message": data["message"] ?? "Giriş başarısız",
      };
    }
  }

  final _formKey = GlobalKey<FormState>();
  final eMailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _moveText = true;
  bool _isLoading = false;

  final List<String> roles = ["SUPER ADMIN", "ADMIN", "UYE"];
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent.shade100,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
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
                    "Kayıt Ol",
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
              const Text(
                "Aramıza katılmak için bilgilerini doldurman yeterli!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
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
                            children: [
                              TextFormField(
                                enabled: !_isLoading,
                                controller: eMailController,
                                decoration: const InputDecoration(
                                  labelText: "E-posta adresinizi giriniz",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains('@')) {
                                    return "Geçerli bir e-posta giriniz";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 17),

                              TextFormField(
                                enabled: !_isLoading,
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  labelText: "Kullanıcı adınızı giriniz",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Kullanıcı adı boş olamaz";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 17),

                              TextFormField(
                                enabled: !_isLoading,
                                controller: passwordController,
                                obscureText: _moveText,
                                decoration: InputDecoration(
                                  labelText: "Şifrenizi giriniz",
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _moveText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _moveText = !_moveText;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Şifre boş bırakılamaz";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 17),

                              TextFormField(
                                enabled: !_isLoading,
                                controller: confirmPasswordController,
                                obscureText: _moveText,
                                decoration: const InputDecoration(
                                  labelText: "Şifrenizi tekrar giriniz",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                                validator: (value) {
                                  if (value != passwordController.text) {
                                    return "Şifreler eşleşmiyor";
                                  } else if (value == null || value.isEmpty) {
                                    return "Lütfen şifrenizi tekrar giriniz";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 17),

                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  enabled: !_isLoading,
                                  labelText: "Rol Seçin",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(
                                    Icons.supervised_user_circle_rounded,
                                  ),
                                ),
                                value: selectedRole,
                                items: roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedRole = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? "Lütfen bir rol seçiniz"
                                    : null,
                              ),
                              const SizedBox(height: 25),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _isLoading = true;
                                            });

                                            final result =
                                                await _signUpServices(
                                                  username: usernameController
                                                      .text
                                                      .trim(),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                  email: eMailController.text
                                                      .trim(),
                                                  role: selectedRole.toString(),
                                                );

                                            setState(() {
                                              _isLoading = false;
                                            });

                                            if (result["statusCode"] == 201) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Kayıt başarılı! Giriş sayfasına yönlendiriliyorsunuz.",
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                              await Future.delayed(
                                                const Duration(seconds: 1),
                                              );
                                              Navigator.pop(
                                                context,
                                              ); // Giriş sayfasına döner
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    result["message"] ??
                                                        "Bir hata oluştu.",
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E88E5),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Kayıt Ol",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
