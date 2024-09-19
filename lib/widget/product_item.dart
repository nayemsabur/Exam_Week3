import 'package:flutter/material.dart';
import '../module/product.dart';
import '../screen/update_product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final Function(String productId) onDelete;

  const ProductItem({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.white,
      title: Text(product.productName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${product.productCode}'),
          Text('Price: \$${product.unitPrice}'),
          Text('Quantity: ${product.quantity}'),
          Text('Total Price: \$${product.totalPrice}'),
          const Divider(),
          ButtonBar(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return UpdateProductScreen(
                        productId: product.id, // Pass the product ID
                        productData: {
                          'ProductName': product.productName,
                          'ProductCode': product.productCode,
                          'UnitPrice': product.unitPrice,
                          'TotalPrice': product.totalPrice,
                          'Qty': product.quantity,
                          'Img': product.productImage, // Pass the image if applicable
                        },
                      );
                    }),
                  );
                  if (result == true) {

                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),


              TextButton.icon(
                onPressed: () {
                  _confirmDelete(context);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(product.id);
              },
            ),
          ],
        );
      },
    );
  }
}
