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

  Future deleteCategory(String docId) async {
    return await FirebaseFirestore.instance
        .collection('categories')
        .doc(docId)
        .delete();
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
        .orderBy('date', descending: true)
        .snapshots();
  }

  // delete transactions
  Future deleteTransaction(String docId) async {
    return await FirebaseFirestore.instance
        .collection('expenses')
        .doc(docId)
        .delete();
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
  Stream<QuerySnapshot> getbudgetDetails(
      {required int month, required int year}) {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    return FirebaseFirestore.instance
        .collection('Budget')
        .where('userId', isEqualTo: userId)
        .where('Month', isEqualTo: month)
        .where('Year', isEqualTo: year)
        .snapshots();
  }

  Future deleteBudget(String docId) async {
    return await FirebaseFirestore.instance
        .collection('Budget')
        .doc(docId)
        .delete();
  }

  Future<double> getTotalSpentForBudget(
      String category, int month, int year) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final expenses = await FirebaseFirestore.instance
        .collection('expenses')
        .where('category', isEqualTo: category)
        .where('linktobudget', isEqualTo: true)
        .where('userId', isEqualTo: userId)
        .where('Month', isEqualTo: month)
        .where('Year', isEqualTo: year)
        .get();

    double totalSpent = 0.0;
    for (var doc in expenses.docs) {
      totalSpent += double.tryParse(doc['amount'].toString()) ?? 0.0;
    }

    return totalSpent;
  }
}

// Database for Goals
class GoalsService {
  // add goals to db
  Future addGoals(Map<String, dynamic> goalsInfoMap) async {
    String docId = FirebaseFirestore.instance.collection('Goals').doc().id;
    return await FirebaseFirestore.instance
        .collection('Goals')
        .doc(docId)
        .set(goalsInfoMap);
  }

  // Read data from db
  Stream<QuerySnapshot> getGoalsDetails() {
    var user = FirebaseAuth.instance.currentUser;
    var userId = user!.uid;
    return FirebaseFirestore.instance
        .collection('Goals')
        .where('userId', isEqualTo: userId)
        // .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // delete Goals
  Future deleteGoals(String docId) async {
    return await FirebaseFirestore.instance
        .collection('Goals')
        .doc(docId)
        .delete();
  }

  Future<double> getTotalSavedForGoal(String goalTitle) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final expenses = await FirebaseFirestore.instance
        .collection('expenses')
        .where('linktogoal', isEqualTo: goalTitle)
        .where('userId', isEqualTo: userId)
        .get();

    double totalSaved = 0.0;
    for (var doc in expenses.docs) {
      totalSaved += doc['amount'] is String
          ? (double.tryParse(doc['amount']) ?? 0.0)
          : (doc['amount'] as num?)?.toDouble() ?? 0.0;
    }

    return totalSaved;
  }
}
