import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'CartPage.dart';

class ItemDetailPage extends StatefulWidget {
  final Product item;

  ItemDetailPage({required this.item});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: Column(
        children: [
          Image.network(widget.item.imageUrl),
          Text(widget.item.name, style: TextStyle(fontSize: 24)),
          Text('السعر: \$${widget.item.price.toStringAsFixed(2)}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (quantity > 1) quantity--;
                  });
                },
              ),
              Text('$quantity', style: TextStyle(fontSize: 24)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              for (int i = 0; i < quantity; i++) {
                Provider.of<Cart>(context, listen: false).addItem(widget.item);
              }
              Navigator.of(context).pop();
            },
            child: Text('إضافة إلى السلة'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            child: Text('عرض السلة'),
          ),
        ],
      ),
    );
  }
}
