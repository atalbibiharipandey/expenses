import 'dart:async';

import 'package:expance/core/common.dart';
import 'package:expance/core/constants/constants.dart';
import 'package:expance/core/utils/imageView/my_duration.dart';
import 'package:expance/presentation/main/bottom_navigation.dart';
import 'package:expance/presentation/main/drawer.dart';

class ScreenAdminMainPage extends StatefulWidget {
  const ScreenAdminMainPage({super.key, this.page});
  final int? page;

  @override
  State<ScreenAdminMainPage> createState() => _ScreenAdminMainPageState();
}

class _ScreenAdminMainPageState extends State<ScreenAdminMainPage>
    with SingleTickerProviderStateMixin {
  final pages = MyPagesController.pages.map((e) => e.page).toList();
  int popCount = 0;
  StreamSubscription? sub;
  @override
  void initState() {
    tabController = TabController(length: pages.length, vsync: this);
    if (widget.page != null) {
      tabController.index = widget.page!;
      Future.delayed(Durations.medium1, () {
        currentIndex.value = widget.page!;
      });
    }
    super.initState();
    sub = NavigatorService.popCount.stream.listen((d) {
      if (d.isNegative && popCount != 0 && popCount.isNegative == false) {
        popCount--;
      } else {
        if (d.isNegative == false) {
          popCount++;
        }
      }
      print("PopCout:- $popCount=======$d=============================");
    });
    Future.delayed(Duration(milliseconds: 200), () {
      popCount = 0;
    });
    // MentorSessionController().getData();
    // ApiFunction.getUserMentorById();
  }

  popCalled() {
    Future.delayed(Duration(milliseconds: 300), () {
      int tmp = popCount;
      if (tmp > 0) {
        print("Pop Called.....$tmp");
        for (var i = 0; i < (tmp); i++) {
          NavigatorService.pop();
        }
        popCount = 0;
      }
      popCount = 0;
    });
  }

  @override
  void dispose() {
    // isolate.dispose();
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        Future.delayed(Duration(milliseconds: 200), () {
          popCount = 0;
        });
        return web
            ? Scaffold(
                body: Row(
                  children: [
                    if (web) ProfileDrawer(),
                    if (web) wsBox10,
                    Expanded(
                      child: MaterialApp(
                        title: constants.appName,
                        scaffoldMessengerKey: globalMessengerKey2,
                        navigatorKey: NavigatorService.navigatorKeySecond,
                        debugShowCheckedModeBanner: false,
                        navigatorObservers: [myObserver],
                        theme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: cPrimery,
                          ),
                          useMaterial3: true,
                          elevatedButtonTheme: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cPrimery,
                            ),
                          ),
                          scaffoldBackgroundColor: cwhite,
                        ),
                        home: ValueListenableBuilder(
                          valueListenable: pageWeb.nameIndex,
                          builder: (context, value, child) {
                            popCalled();
                            return pageWeb.pageList[pageWeb.nameIndex.value]!;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : DefaultTabController(
                initialIndex: 0,
                length: pages.length,
                animationDuration: MyDuration.durationMil500,
                child: Scaffold(
                  drawer: ProfileDrawer(),
                  body: Builder(
                    builder: (context) {
                      return TabBarView(
                        controller: tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: pages.map((e) => e).toList(),
                      );
                    },
                  ),
                  bottomNavigationBar: MyPagesController.bottomNavigationBar(
                    page: widget.page,
                  ),
                ),
              );
      },
    );
  }
}
