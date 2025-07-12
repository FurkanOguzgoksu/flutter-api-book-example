import 'package:film_app/features_personal/user_model.dart';
import 'package:film_app/widgets/constant.dart';
import 'package:flutter/material.dart';

class PagePersonelInformation extends StatelessWidget {
  final UserModel? personal;
  const PagePersonelInformation({super.key, this.personal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: const Text("Kişisel Bilgilerim"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  personal?.avatarUrl ?? "",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person_2_outlined, size: 100);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(label: "ID", value: personal?.id ?? "-"),
                      InfoRow(label: "Email", value: personal?.email ?? "-"),
                      InfoRow(
                        label: "Kullanıcı Adı",
                        value: personal?.username ?? "-",
                      ),

                      InfoRow(label: "Rol", value: personal?.role ?? "-"),
                      const Divider(),
                      InfoRow(
                        label: "Oluşturulma Tarihi",
                        value: personal?.createdAt ?? "-",
                      ),
                      InfoRow(
                        label: "Güncellenme Tarihi",
                        value: personal?.updateAt ?? "-",
                      ),
                      const Divider(),
                      Text("Access Token:\n${personal?.accessToken ?? "-"}"),
                      const SizedBox(height: 10),
                      Text("Refresh Token:\n${personal?.refreshToken ?? "-"}"),
                    ],
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

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
