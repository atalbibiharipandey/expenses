import 'package:expance/core/common.dart';
import 'package:expance/models/model.paginate.dart';
import 'package:expance/services/local_db/local_db.dart';

class Transaction extends BaseModel {
  String? tId;
  String? name;
  num? amount;
  String? category;
  bool? income;
  DateTime? date;

  Transaction({
    this.tId,
    this.category,
    this.date,
    this.income,
    this.name,
    this.amount,
  }) {
    tId ??= DateTime.now().millisecondsSinceEpoch.toString();
  }

  Transaction create({Transaction? data}) => data ?? Transaction();

  Transaction fromJson(Map<String, dynamic> json) => Transaction.fromJson(json);

  static ModelPaginate<Transaction> paginate(Map<String, dynamic> json) =>
      ModelPaginate<Transaction>.fromJson(
        json,
        (p0) => Transaction.fromJson(p0),
      );
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      tId: json['tId'],
      category: json['category'],
      income: json['income'] ?? false,
      name: json['name'],
      amount: json['amount'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tId': tId,
      'category': category,
      'income': income ?? false,
      'name': name,
      'amount': amount,
      'date': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}
