import 'package:fintrack_app/database.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  CategoriesPage({super.key});

  final FirestoreService firestoreService = FirestoreService();

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 600,
            left: 25,
            child: _createNewBtn(),
          )
        ],
      ),
    );
  }

  // Function to show the add category dialog
  void _addCategoryDialog() {
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextField(
            controller: categoryController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () {
                FirestoreService().addCategory(categoryController.text);

                Navigator.pop(context);
              },
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _createNewBtn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(340, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _addCategoryDialog();
        },
        child: const Text(
          'Create New Category',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
