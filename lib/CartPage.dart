import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
