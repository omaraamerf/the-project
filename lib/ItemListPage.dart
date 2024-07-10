import 'package:flutter/material.dart';
import 'CartPage.dart';
import 'ItemDetailPage.dart';

class ItemListPage extends StatelessWidget {
  final String category;
  final List<Product> items;

  ItemListPage({required this.category, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) => ListTile(
          leading: Image.network(items[index].imageUrl, width: 50, height: 50),
          title: Text(items[index].name),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ItemDetailPage(item: items[index]),
            ));
          },
        ),
      ),
    );
  }
}
