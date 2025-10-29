import 'package:expance/core/common.dart';
import 'package:expance/core/utils/imageView/my_duration.dart';
import 'package:expance/core/widgets/curved-bottom-bar/curved_navigation_bar.dart';
import 'package:expance/presentation/category/screen_category.dart';
import 'package:expance/presentation/chart/screen_chart.dart';
import 'package:expance/presentation/home/screen_home.dart';
import 'package:expance/presentation/transactions/screen_transactions.dart';

ValueNotifier<int> currentIndex = ValueNotifier(0);

late TabController tabController;

class MyPagesController {
  static goToPage(int i) {
    tabController.index = i;
    currentIndex.value = i;
    refreshCurvedNavigationBar?.call(i);
  }

  static final pages = [mentorHome, category, transaction, mentorWallet];

  static CurvedNavigationBar bottomNavigationBar({int? page}) {
    Future.delayed(MyDuration.durationMil200, () {
      currentIndex.value = page ?? tabController.index ?? 0;
      refreshCurvedNavigationBar?.call(null);
    });
    return CurvedNavigationBar(
      backgroundColor: ctransparent,
      buttonLabelColor: cPrimery,
      buttonBackgroundColor: cwhite,
      color: cwhite,
      index: tabController.index,
      items: pages.map((e) => e.navigationBar).toList(),
      onTap: (index) {
        tabController.index = index;
        currentIndex.value = index;
      },
    );
  }

  static final mentorHome = (
    page: ScreenHomePage(),
    navigationBar: CurvedNavigationBarItem(
      icon: AnimatedBuilder(
        animation: currentIndex,
        builder: (context, ch) {
          final ci = currentIndex.value;

          return Icon(
            Icons.home_outlined,
            color: 3 == ci ? cPrimery : HexColor("#9DB2CE"),
          );
        },
      ),
      label: "Home",
    ),
  );
  static final category = (
    page: ScreenCategoryPage(),
    navigationBar: CurvedNavigationBarItem(
      icon: AnimatedBuilder(
        animation: currentIndex,
        builder: (context, ch) {
          final ci = currentIndex.value;

          return Icon(
            Icons.category_outlined,
            color: 1 == ci ? cPrimery : HexColor("#9DB2CE"),
          );
        },
      ),
      label: "Category",
    ),
  );
  static final transaction = (
    page: ScreenTransactionsPage(),
    navigationBar: CurvedNavigationBarItem(
      icon: AnimatedBuilder(
        animation: currentIndex,
        builder: (context, ch) {
          final ci = currentIndex.value;

          return Icon(
            Icons.history,
            color: 2 == ci ? cPrimery : HexColor("#9DB2CE"),
          );
        },
      ),
      label: "History",
    ),
  );
  static final mentorWallet = (
    page: ScreenChartPage(),
    navigationBar: CurvedNavigationBarItem(
      icon: AnimatedBuilder(
        animation: currentIndex,
        builder: (context, ch) {
          final ci = currentIndex.value;

          return Icon(
            LucideIcons.chartArea,
            color: 3 == ci ? cPrimery : HexColor("#9DB2CE"),
          );
        },
      ),
      label: "Chart",
    ),
  );
}
