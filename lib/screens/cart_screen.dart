import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('Your Cart')),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      const Spacer(),
                      Chip(
                        label: Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .titleLarge
                                  ?.color),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<Orders>(context, listen: false).addOrder(
                              cart.item.values.toList(), cart.totalAmount);
                          cart.clear();
                        },
                        child: Text(
                          'Order Now',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 10),
            Expanded(
              //flex: 2,
              child: ListView.builder(
                  itemCount: cart.item.length,
                  itemBuilder: (ctx, i) => CartItem(
                        cart.item.values.toList()[i].id,
                        cart.item.keys.toList()[i],
                        cart.item.values.toList()[i].price,
                        cart.item.values.toList()[i].quantity,
                        cart.item.values.toList()[i].title,
                      )),
            ),
          ],
        ));
  }
}
