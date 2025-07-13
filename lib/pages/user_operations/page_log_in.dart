import 'dart:convert';
import 'package:film_app/pages/user_operations/page_forgot_password.dart';
import 'package:film_app/pages/user_operations/page_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:film_app/widgets/constant.dart';
import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_home.dart';
import 'package:film_app/services/auth_helper.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: LogInPage()),
);

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>(); // Kontrol için anahtar
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _moveText = true;
  bool _isLoading = false;

  static Future<Map<String, dynamic>> _loginServices({
    String? username,
    String? password,
  }) async {
    final Uri url = Uri.parse(kUserLoginLink);
    final response = await http.post(
      url,
      headers: {
        "accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode({"username": username, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["data"] != null) {
      return {"statusCode": 200, "userData": data["data"]};
    } else {
      return {
        "statusCode": response.statusCode,
        "message": data["message"] ?? "Giriş başarısız",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFDCEDC8), // Açık yeşil zemin
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF43A047),
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Hoşgeldin!'),
                    TypewriterAnimatedText('Yeni Kitaplar Seni Bekliyor...'),
                  ],
                  totalRepeatCount: 100,
                  pause: const Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "📚 Günün Sözü:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "“Kitaplar ruhun ilacıdır.”",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
              const Text("Giriş Yap", style: TextStyle(fontSize: 30)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              enabled: !_isLoading,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? "Kullanıcı adı boş bırakılamaz"
                                  : null,
                              decoration: InputDecoration(
                                labelText: "Kullanıcı adınızı giriniz",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _moveText,
                              enabled: !_isLoading,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? "Şifre boş bırakılamaz"
                                  : null,
                              decoration: InputDecoration(
                                labelText: "Şifrenizi giriniz",
                                border: const OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: kBlackColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _moveText = !_moveText;
                                    });
                                  },
                                  icon: Icon(
                                    _moveText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PageForgotPassword(),
                                        ),
                                      );
                                    },
                              child: Text(
                                "Şifrenizi mi unuttunuz?",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: kBlackColor,
                                ),
                              ),
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PageSignUp(),
                                              ),
                                            );
                                          },
                                    child: Text(
                                      "Kayıt Ol",
                                      style: TextStyle(color: kTextWhiteColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF66BB6A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() => _isLoading = true);

                                              final result =
                                                  await _loginServices(
                                                    username:
                                                        _usernameController.text
                                                            .trim(),
                                                    password:
                                                        _passwordController.text
                                                            .trim(),
                                                  );

                                              setState(
                                                () => _isLoading = false,
                                              );

                                              if (result["statusCode"] == 200) {
                                                final personal =
                                                    UserModel.fromJson(
                                                      result["userData"],
                                                    );
                                                await AuthHelper.saveUserToPrefs(
                                                  personal,
                                                );

                                                if (!context.mounted) return;

                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => PageHome(
                                                      personal: personal,
                                                    ),
                                                  ),
                                                  (route) => false,
                                                );
                                              } else if (result["statusCode"] ==
                                                  401) {
                                                if (!context.mounted) return;

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      "Kullanıcı adı veya şifre hatalı!",
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else {
                                                if (!context.mounted) return;

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      result["message"],
                                                    ),
                                                    backgroundColor:
                                                        Colors.blueGrey,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    child: Text(
                                      "Giriş Yap",
                                      style: TextStyle(color: kTextWhiteColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: kBlackColor,
                                    thickness: 1, // Kalınlık
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Hesabını Bağla",
                                    style: TextStyle(color: kBlackColor),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: kBlackColor,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Image.asset("images/google1.webp"),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: SizedBox(
                                    height: 40,
                                    child: Image.asset("images/x.png"),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
