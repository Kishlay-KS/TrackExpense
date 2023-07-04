import 'package:flutter/material.dart';

class ExpenseDatabase {
  String amount;
  String category;
  String mode;
  String type;
  DateTime time;
  ExpenseDatabase(
      {required this.amount,
      required this.category,
      required this.mode,
      required this.type,
      required this.time});
  factory ExpenseDatabase.fromJson(Map<String, dynamic> json) =>
      ExpenseDatabase(
          amount: json['amount'],
          category: json['category'],
          mode: json['mode'],
          type: json['type'],
          time: json['time'].toDate());

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'category': category,
        'mode': mode,
        'type': type,
        'time': time
      };
}
