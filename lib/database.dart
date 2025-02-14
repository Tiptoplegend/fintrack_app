import 'dart:developer';
import 'dart:ffi';
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

class GoalService {
  final CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');

  // Add Goal
  Future<void> addGoal(String title, double targetAmount) async {
    await goalsCollection.add({
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': 0.0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
