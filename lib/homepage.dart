import 'package:flutter/material.dart';
import 'CartPage.dart';
import 'ItemListPage.dart';

class HomePage extends StatelessWidget {
  final List<String> categories = ['العصائر', 'الفروج'];
  final Map<String, List<Product>> items = {
    'العصائر': [
      Product(
          name: 'عصير برتقال',
          price: 5.0,
          imageUrl: 'https://example.com/orange_juice.jpg'),
      Product(
          name: 'عصير تفاح',
          price: 6.0,
          imageUrl: 'https://example.com/apple_juice.jpg'),
      Product(
          name: 'عصير مانجو',
          price: 7.0,
          imageUrl: 'https://example.com/mango_juice.jpg')
    ],
    'الفروج': [
      Product(
          name: 'فروج مشوي',
          price: 20.0,
          imageUrl: 'https://example.com/grilled_chicken.jpg'),
      Product(
          name: 'فروج مقلي',
          price: 15.0,
          imageUrl: 'https://example.com/fried_chicken.jpg')
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('المطعم الشرقي'),
      ),
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: categories.length,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ItemListPage(
                    category: categories[index],
                    items: items[categories[index]] ?? [],
                  ),
                ));
              },
              child: GridTile(
                child: Image.network(
                    'https://example.com/${categories[index]}.jpg',
                    fit: BoxFit.cover),
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  title: Text(categories[index]),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left:
                MediaQuery.of(context).size.width / 2 - 28, // Center the button
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
    );
  }
}
