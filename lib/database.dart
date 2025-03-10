import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future addUser(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }
}

class FirestoreService {
  // DATABASE FOR CategoriesPage
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  Future<DocumentReference<Object?>> addCategory(String categoryName) async {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    // log(userId.toString());
    return await _categoriesCollection.add({
      'userId': userId,
      'name': categoryName,
      'Timestamp': Timestamp.now(),
    });
  }

  Future<List<QueryDocumentSnapshot>?> getCategories() async {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    final CollectionReference categoriesCollection =
        FirebaseFirestore.instance.collection('categories');
    var query =
        await categoriesCollection.where('userId', isEqualTo: userId).get();
    return query.docs;
  }
}

class Analytics {
  final CollectionReference _TransactionsCollection =
      FirebaseFirestore.instance.collection('Transactions');

  Future<DocumentReference<Object?>> addTransaction(
      String category, double amount, String? notes) async {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;

    return await _TransactionsCollection.add({
      'userId': userId,
      'category': category,
      'expenseAmount': amount,
      'expenseDate': Timestamp.now(),
      'notes': notes ?? "",
    });
  }

  Future<List<QueryDocumentSnapshot>?> getTransactions() async {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;

    var query = await _TransactionsCollection.where('userId', isEqualTo: userId)
        .orderBy('expenseDate', descending: true)
        .get();

    return query.docs;
  }
}
