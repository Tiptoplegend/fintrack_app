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

// DATABASE FOR TransactionPage

class Transactionservice {
  // add transaction to db
  Future addTransaction(Map<String, dynamic> expenseInfoMap) async {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    String docId = FirebaseFirestore.instance.collection('expenses').doc().id;
    return await FirebaseFirestore.instance
        .collection('expenses')
        .doc(docId)
        .set(expenseInfoMap);
  }

// get transaction/expense from db
  Stream<QuerySnapshot> getexpenseDetails() {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    return FirebaseFirestore.instance
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}

//Database for Budgetpage

class Budgetservice {
  // add budget to db
  Future addbudget(Map<String, dynamic> budgetinfoMap) async {
    String docId = FirebaseFirestore.instance.collection('Budget').doc().id;
    return await FirebaseFirestore.instance
        .collection('Budget')
        .doc(docId)
        .set(budgetinfoMap);
  }

  // get budget from db
  Stream<QuerySnapshot> getbudgetDetails() {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    return FirebaseFirestore.instance
        .collection('Budget')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
