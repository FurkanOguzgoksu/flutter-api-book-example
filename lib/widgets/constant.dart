import 'package:flutter/material.dart';

final String kUserLoginLink = "https://api.freeapi.app/api/v1/users/login";
final String kUserRegisterLink =
    "https://api.freeapi.app/api/v1/users/register";
final String kUserForgotPasswordLink =
    "https://api.freeapi.app/api/v1/users/forgot-password";

final Color kBackgroundColor = Colors.lightGreen;
final Color kTextWhiteColor = Colors.white;
final Color kBlackColor = Colors.black;
final double kBookPrice = 1.00;

final List<Map<String, String>> ibanList = [
  {"bankName": "Ziraat Bankası", "iban": "TR11 1111 1111 1111 1111 1111 11"},
  {"bankName": "Kuveyt Türk", "iban": "TR22 2222 2222 2222 2222 2222 22"},
  {"bankName": "Vakıfbank", "iban": "TR33 3333 3333 3333 3333 3333 33"},
];

List<String> images = [
  "http://books.google.com/books/content?id=KA9QDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
  "https://books.google.com/books/content?id=bmDFjgEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api",
  "http://books.google.com/books/content?id=A31lDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
  "http://books.google.com/books/content?id=lT3LDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
  "http://books.google.com/books/content?id=lAOqDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
];

List<Map<String, dynamic>> bookCategories = [
  {"icon": Icons.menu_book, "title": "Romanlar"},
  {"icon": Icons.child_care, "title": "Çocuk Kitapları"},
  {"icon": Icons.history_edu, "title": "Tarih"},
  {"icon": Icons.science, "title": "Bilim"},
  {"icon": Icons.psychology, "title": "Felsefe"},
  {"icon": Icons.auto_stories, "title": "Kişisel Gelişim"},
  {"icon": Icons.favorite, "title": "Aşk"},
  {"icon": Icons.sports_esports, "title": "Fantastik"},
];
