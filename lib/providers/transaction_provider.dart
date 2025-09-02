import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionModel {
  int? id;
  String title;
  double amount;
  String type;
  String date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }
}

class TransactionProvider extends ChangeNotifier {
  Database? _db;
  List<TransactionModel> transactions = [];

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  // Initialize Database
  Future<void> initDB() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'fintrack.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, type TEXT, date TEXT)',
        );
      },
      version: 1,
    );
    await fetchTransactions();
  }

  // Fetch all transactions
  Future<void> fetchTransactions() async {
    if (_db == null) return;
    final List<Map<String, dynamic>> maps = await _db!.query(
      'transactions',
      orderBy: 'date DESC',
    );

    transactions = List.generate(maps.length, (i) {
      return TransactionModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        type: maps[i]['type'],
        date: maps[i]['date'],
      );
    });

    calculateTotals();
    notifyListeners();
  }

  // Add transaction
  Future<void> addTransaction(TransactionModel tx) async {
    if (_db == null) return;
    await _db!.insert(
      'transactions',
      tx.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await fetchTransactions();
  }

  // Delete transaction
  Future<void> deleteTransaction(int id) async {
    if (_db == null) return;
    await _db!.delete('transactions', where: 'id = ?', whereArgs: [id]);
    await fetchTransactions();
  }

  // Calculate totals
  void calculateTotals() {
    totalIncome = 0.0;
    totalExpense = 0.0;

    for (var tx in transactions) {
      if (tx.type == 'income') {
        totalIncome += tx.amount;
      } else if (tx.type == 'expense') {
        totalExpense += tx.amount;
      }
    }
  }

  // Remaining balance
  double calculateBalance() {
    return totalIncome - totalExpense;
  }
}
