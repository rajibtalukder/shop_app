import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imgUrl;
  bool isFavourite;

  Product({
    required this.title,
    required this.description,
    required this.price,
    required this.imgUrl,
     required this.id,
    this.isFavourite = false,
  });

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
