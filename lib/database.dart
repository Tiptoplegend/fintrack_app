import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintrack_app/FAB%20pages/Categories.dart';

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }
}

// DATABASE FOR CategoriesPage

class FirestoreService {
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<void> addCategory(String categoryName) {
    return _categoriesCollection.add({
      'name': categoryName,
    });
  }
}
