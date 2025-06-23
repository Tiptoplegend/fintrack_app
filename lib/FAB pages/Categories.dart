import 'package:fintrack_app/database.dart';
import 'package:flutter/material.dart';

class Category {
  String? docId;
  String name;
  bool isUserCreated;
  bool isEnabled;
  IconData? icon;

  Category({
    this.docId,
    required this.name,
    this.isUserCreated = false,
    this.isEnabled = true,
    this.icon,
  });
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    categories.addAll([
      Category(name: "Food", icon: Icons.fastfood),
      Category(name: "Transportation", icon: Icons.directions_car),
      Category(name: "Entertainment", icon: Icons.movie),
      Category(name: "Utilities", icon: Icons.home_repair_service),
      Category(name: "Shopping", icon: Icons.shopping_bag),
    ]);
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final catsSnapshot = await firestoreService.getCategories();
    if (catsSnapshot != null) {
      var catsList = catsSnapshot.map((snap) {
        var data = snap.data() as Map<String, dynamic>;
        // log(data.toString());
        return Category(
          docId: snap.id,
          name: data['name'],
          isUserCreated: true,
          isEnabled: true,
        );
      }).toList();

      setState(() {
        categories.addAll(catsList);
      });
    }
  }

  void _addCategory(String categoryName) async {
    try {
      final docRef = await FirestoreService().addCategory(categoryName);
      setState(() {
        categories.add(
          Category(
            docId: docRef.id,
            name: categoryName,
            isUserCreated: true,
            isEnabled: true,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding category: $e')),
      );
    }
  }

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
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (categoryController.text.trim().isNotEmpty) {
                  _addCategory(categoryController.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  // The "Create New Category" button at the bottom.
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
        onPressed: _addCategoryDialog,
        child: const Text(
          'Create New Category',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // The widget that builds the list of categories.
  Widget _CategoriesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(
                category.icon ?? Icons.category,
                size: 30,
                color: Colors.green,
              ),
              title: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Only the user-created categories will get the toggle switch.
              // trailing: category.isUserCreated
              //     ? Switch(
              //         value: category.isEnabled,
              //         onChanged: (value) {
              //           setState(() {
              //             category.isEnabled = value;
              //           });
              //         },
              //         activeColor: Colors.green,
              //       )
              //     : null,
              trailing: category.isUserCreated
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (category.docId != null) {
                          try {
                            await FirestoreService()
                                .deleteCategory(category.docId!);
                            setState(() {
                              categories.removeAt(index);
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error deleting category: $e')),
                            );
                          }
                        }
                      },
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF005341), Color(0xFF00A86B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _CategoriesList(),
            _createNewBtn(),
          ],
        ),
      ),
    );
  }
}
