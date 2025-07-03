import 'package:film_app/features_book/features_volume_info.dart';

class Book {
  final int? id;
  final VolumeInfo? volumeInfo;
  final double? price;

  Book({this.id, this.volumeInfo, this.price});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"],
      volumeInfo: VolumeInfo.fromJson(json["volumeInfo"]),
      price: json["saleInfo"]?["listPrice"]?["amount"]?.toDouble(),
    );
  }
}
