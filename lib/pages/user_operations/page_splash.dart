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
    // "Kullanıcı daha önce giriş yapmış mı, yapmamış mı?"
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    if (token != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hoş geldiniz! Oturumunuz açık."),
          duration: const Duration(seconds: 3),
        ),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageHome(personal: widget.personal),
        ),
      );
    } else {
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
