import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_home.dart';
import 'package:film_app/pages/user_operations/page_log_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final UserModel? personal;
  const SplashPage({super.key, this.personal});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("id");
    final username = prefs.getString("username");
    final email = prefs.getString("email");
    final accessToken = prefs.getString("accessToken");
    final refreshToken = prefs.getString("refreshToken");

    if (accessToken != null && username != null) {
      final personal = UserModel(
        id: id,
        username: username,
        email: email,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hoş geldiniz! Oturumunuz açık."),
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PageHome(personal: personal)),
      );
    } else {
      // Token yoksa login ekranına gönder
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
