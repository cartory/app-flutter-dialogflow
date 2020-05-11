import 'package:flutter/material.dart';

import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:app_dialog/models/product.dart';
import 'package:app_dialog/providers/product_provider.dart';
import 'package:app_dialog/views/product/product_card.dart';

class ProductList extends StatelessWidget {
  static ProductList _instance = ProductList();
  static ProductList get instance => _instance;
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: ProductProvider.instance.reference.orderByKey(),
        itemBuilder: (_, snapshot, animation, x) =>
            ProductCard(Product.fromSnapshot(snapshot.key, snapshot.value)),
        defaultChild: Center(child: CircularProgressIndicator()));
  }
}

class ProductListQuery extends StatelessWidget {
  static ProductListQuery _instance = ProductListQuery();
  static ProductListQuery get instance => _instance;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: ProductProvider.instance.promoQuery,
        itemBuilder: (_, snapshot, animation, x) =>
            ProductCard(Product.fromSnapshot(snapshot.key, snapshot.value)),
        defaultChild: Center(child: CircularProgressIndicator()));
  }
}
