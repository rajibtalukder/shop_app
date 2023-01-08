import 'package:flutter/material.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt- it is preety red..!',
      price: 29.99,
      imgUrl: 'https://m.media-amazon.com/images/I/714tu5YxYSL._UX679_.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A great pair of trousers',
      price: 59.99,
      imgUrl:
          'https://rukminim1.flixcart.com/image/832/832/xif0q/trouser/l/v/j/30-trouser0021-tanip-original-imaggspdhyfsa2yt.jpeg?q=70',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scraf',
      description: 'A ward and cozy-exactly we need for the winter',
      price: 19.99,
      imgUrl: 'https://i.ebayimg.com/images/g/tzAAAOSwLjxafaYe/s-l1600.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A pan',
      description: 'Prepared for any meal you want',
      price: 49.99,
      imgUrl: 'https://m.media-amazon.com/images/I/61TSjT1ZYpL._AC_SX522_.jpg',
    ),
  ];

  List<Product> get favouriteItems {
    return items.where((prodItem) => prodItem.isFavourite).toList();
  }

  //var _showFavouritesOnly = false;
  List<Product> get items {
    // if(_showFavouritesOnly){
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  // void showFavouritesOnly(){
  //   _showFavouritesOnly=true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _showFavouritesOnly=false;
  //   notifyListeners();
  // }

  Future<void> fetctAndSetProducts() async {
    final url = Uri.parse(
        'https://shopapp-4c0d0-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      print(json.decode(response.body));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-4c0d0-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imgUrl': product.imgUrl,
            'isFavourite': product.isFavourite,
          }));
      //print(json.decode(response.body));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // ignore: avoid_print
      print(error);
      // ignore: use_rethrow_when_possible
      throw error;
    }
  }

  void updateProduuct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
      // ignore: avoid_print
      print('Edited');
    } else {
      // ignore: avoid_print
      print('update not working');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
