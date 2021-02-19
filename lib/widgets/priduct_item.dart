import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  // final String description;
  // final double price;
  final String imageUrl;
  // bool isFavorite;

  ProductItem({
    @required this.id,
    @required this.imageUrl,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(imageUrl),
    );
  }
}
