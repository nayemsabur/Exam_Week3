import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../module/product.dart';
import '../widget/product_item.dart';
import 'add__product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key, });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _inProgress = false;
  late final Product product ;
  @override
  void initState() {
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product list'),
        actions: [
          IconButton(
            onPressed: getProductList,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _inProgress
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            return ProductItem(product: productList[index], );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 16);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const AddNewProductScreen();
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Fetch product list
  Future<void> getProductList() async {
    setState(() {
      _inProgress = true;
    });

    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/ReadProduct');
    Response response = await get(uri);

    if (response.statusCode == 200) {
      List<Product> loadedProducts = [];
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      for (var item in jsonResponse['data']) {
        Product product = Product(
          id: item['_id'],
          productName: item['ProductName'] ?? '',
          productCode: item['ProductCode'] ?? '',
          productImage: item['Img'] ?? '',
          unitPrice: item['UnitPrice'] ?? '',
          quantity: item['Qty'] ?? '',
          totalPrice: item['TotalPrice'] ?? '',
          createdAt: item['CreatedDate'] ?? '',
        );
        loadedProducts.add(product);
      }
      setState(() {
        productList = loadedProducts;
      });
    } else {
      print('Error fetching products: ${response.statusCode} ${response.body}');
    }

    setState(() {
      _inProgress = false;
    });
  }



}
