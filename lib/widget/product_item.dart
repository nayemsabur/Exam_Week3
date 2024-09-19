import 'package:flutter/material.dart';
import '../module/product.dart';
import '../screen/update_product.dart';
import 'package:http/http.dart';

class ProductItem extends StatefulWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.white,
      title: Text(widget.product.productName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${widget.product.productCode}'),
          Text('Price: \$${widget.product.unitPrice}'),
          Text('Quantity: ${widget.product.quantity}'),
          Text('Total Price: \$${widget.product.totalPrice}'),
          const Divider(),
          ButtonBar(
            children: [
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return UpdateProductScreen(
                        productId: widget.product.id,
                        productData: {
                          'ProductName': widget.product.productName,
                          'ProductCode': widget.product.productCode,
                          'UnitPrice': widget.product.unitPrice,
                          'TotalPrice': widget.product.totalPrice,
                          'Qty': widget.product.quantity,
                          'Img': widget.product.productImage,
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
                _deleteProduct(widget.product.id);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(String id)async{
    Uri uri = Uri.parse( "http://164.68.107.70:6060/api/v1/DeleteProduct/$id");
    Response response= await get(uri);
    print(response.statusCode);
    if(response.statusCode ==200){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success")));
      setState(() {

      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed")));
      setState(() {

      });
    }
  }
}
