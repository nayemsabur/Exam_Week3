import 'package:flutter/material.dart';
import 'screen/product_screen.dart';

void main(){
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListScreen(),
    );
  }
}
