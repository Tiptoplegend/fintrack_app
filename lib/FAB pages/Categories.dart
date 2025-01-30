import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AppBar(
          leading: Icon(Icons.arrow_back_ios_new),
          title: Text('Categories'),
        ),
      ]),
    );
  }
}
