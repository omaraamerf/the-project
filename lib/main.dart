import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

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

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final TextEditingController addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('السلة'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المبلغ الإجمالي: \$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('عدد المنتجات: ${cart.items.length}',
                style: TextStyle(fontSize: 20)),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(cart.items[index].name),
                  trailing:
                      Text('\$${cart.items[index].price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'أدخل عنوانك',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (addressController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('تم الإرسال'),
                          content: Text('تم إرسال طلبك بنجاح!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                Provider.of<Cart>(context, listen: false)
                                    .clear();
                                Navigator.of(context).pop();
                              },
                              child: Text('موافق'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('خطأ'),
                          content: Text('يرجى إدخال العنوان!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('موافق'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('إرسال'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false).clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('حذف'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class Cart with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.price);

  void addItem(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
