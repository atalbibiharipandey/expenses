import 'package:expance/core/common.dart';
import 'package:expance/presentation/category/screen_category.dart';
import 'package:expance/presentation/chart/screen_chart.dart';
import 'package:expance/presentation/home/screen_home.dart';
import 'package:expance/presentation/transactions/screen_transactions.dart';

class ManageWebPage {
  final names = (
    category: "category",
    transaction: "transaction",
    home: "home",
    chart: "chart",
  );
  ValueNotifier<String> nameIndex = ValueNotifier("home");
  Map<String, Widget> get pageList => {
    names.home: ScreenHomePage(),
    names.category: ScreenCategoryPage(),
    names.transaction: ScreenTransactionsPage(),
    names.chart: ScreenChartPage(),
  };
}
