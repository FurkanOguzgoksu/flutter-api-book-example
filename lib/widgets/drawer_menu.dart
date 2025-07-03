import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/pages/page_personel_information.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DrawerMenu extends StatelessWidget {
  final UserModel? personal;
  const DrawerMenu({super.key, this.personal});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(color: kBackgroundColor),
              child: Center(
                child: Text(
                  "Kitap Uygulamasına Hoş Geldiniz",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Ana Sayfa"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil Bilgilerim"),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PagePersonelInformation(personal: personal),
                ),
              ),
            },
          ),

          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Kitaplar"),
            onTap: () => {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Sosyal Medyalarımız",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Instagram"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_fill),
            title: const Text("YouTube"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text("Twitter"),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Ayarlar"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Çıkış"),
            onTap: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
