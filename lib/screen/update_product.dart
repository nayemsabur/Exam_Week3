import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const UpdateProductScreen({
    Key? key,
    required this.productId,
    required this.productData,
  }) : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController _productNameTEController;
  late TextEditingController _unitPriceTEController;
  late TextEditingController _totalPriceTEController;
  late TextEditingController _quantityTEController;
  late TextEditingController _imageTEController;
  late TextEditingController _codeTEController;
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing product data
    _productNameTEController = TextEditingController(text: widget.productData['ProductName']);
    _unitPriceTEController = TextEditingController(text: widget.productData['UnitPrice']);
    _totalPriceTEController = TextEditingController(text: widget.productData['TotalPrice']);
    _quantityTEController = TextEditingController(text: widget.productData['Qty']);
    _imageTEController = TextEditingController(text: widget.productData['Img']);
    _codeTEController = TextEditingController(text: widget.productData['ProductCode']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildUpdateProductForm(),
        ),
      ),
    );
  }

  Widget _buildUpdateProductForm() {
    return Column(
      children: [
        TextFormField(
          controller: _productNameTEController,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Name', labelText: 'Product Name'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _unitPriceTEController,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Unit Price', labelText: 'Unit Price'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _totalPriceTEController,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Total Price', labelText: 'Total Price'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _quantityTEController,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Quantity', labelText: 'Quantity'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _imageTEController,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Image', labelText: 'Product Image'),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _codeTEController,
          decoration:  InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Product code', labelText: 'Product Code'),
        ),
        SizedBox(height: 10),
        const SizedBox(height: 16),
        _inProgress
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
          ),
          onPressed: _onTapUpdateProductButton,
          child: const Text('Update Product'),
        )
      ],
    );
  }

  void _onTapUpdateProductButton() {
    updateProduct(widget.productId);
  }

  Future<void> updateProduct(String productId) async {
    setState(() {
      _inProgress = true;
    });

    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/UpdateProduct/$productId');
    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text,
      "ProductCode": _codeTEController.text,
      "ProductName": _productNameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };
    Response response = await post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product updated successfully')));

      Navigator.pop(context, true);
    }
    setState(() {
      _inProgress = false;
    });
  }

  @override
  void dispose() {
    _productNameTEController.dispose();
    _unitPriceTEController.dispose();
    _totalPriceTEController.dispose();
    _quantityTEController.dispose();
    _imageTEController.dispose();
    _codeTEController.dispose();
    super.dispose();
  }
}
