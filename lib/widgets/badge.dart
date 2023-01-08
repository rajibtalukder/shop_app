import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
    required this.value,
    required this.color,
  }) : super(key: key);
  final Widget child;
  final String value;
  final Color color; //********************************

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      child,
      Positioned(
          top: 8,
          right: 8,
          child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // ignore: prefer_if_null_operators, unnecessary_null_comparison
                color: color != null
                    ? color
                    : Theme.of(context).colorScheme.secondary,
              ),
              constraints: const BoxConstraints(
                minHeight: 16,
                minWidth: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              )))
    ]);
  }
}
