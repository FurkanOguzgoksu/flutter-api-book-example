import 'dart:async';
import 'package:film_app/features_personal/user_model.dart';
import 'package:flutter/material.dart';

class FirstBanner extends StatefulWidget {
  final UserModel? personal;
  final bool isConnected;

  const FirstBanner({
    super.key,
    required this.isConnected,
    required this.personal,
  });

  @override
  State<FirstBanner> createState() => _FirstBannerState();
}

class _FirstBannerState extends State<FirstBanner> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    // Yalnızca bağlantı varsa saniyelik görünme işlemi yapılır
    if (widget.isConnected) {
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          // Bu widget hala ekranda mı? Çökmemesi için kontrol edilir.
          setState(() {
            _visible = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isConnected && !_visible) return const SizedBox.shrink();
    if (!_visible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: widget.isConnected ? Colors.green : Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.isConnected ? Icons.waving_hand : Icons.wifi_off,
            color: widget.isConnected ? Colors.amberAccent : Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            widget.isConnected
                ? "Hoşgeldin ${widget.personal?.username ?? "Bilinmeyen kullanıcı"}"
                : "İnternet bağlantısı yok",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
