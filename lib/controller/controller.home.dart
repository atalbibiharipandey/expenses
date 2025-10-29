import 'package:expance/core/common.dart';
import 'package:expance/models/model.transaction.dart';

class ControllerHome {
  final cDay = DateTime.now();
  num currentBalance = 0;
  num currentIncome = 0;
  num currentExpenses = 0;
  Map<String, double> categoryTotals = {};
  List<Transaction> transaction = [];
  getCurrentMontExpances() async {
    transaction = await g.coll.transaction.getAll(
      fromJson: g.m.transaction.fromJson,
      where: (p0) =>
          p0.date?.format(pattern: "MM/yyyy") ==
          cDay.format(pattern: "MM/yyyy"),
    );
    for (var e in transaction) {
      if (e.income != true) {
        categoryTotals[(e.category ?? "a")] =
            ((categoryTotals[e.category!] ?? 0) + (e.amount ?? 0));
      }
      if (e.income == true) {
        currentIncome += (e.amount ?? 0);
      } else {
        currentExpenses += (e.amount ?? 0);
      }
    }
    currentBalance = currentIncome - currentExpenses;
  }
}
