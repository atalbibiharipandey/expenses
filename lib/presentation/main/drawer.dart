import 'package:expance/core/common.dart';
import 'package:expance/presentation/main/bottom_navigation.dart';

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cPrimery,
      child: Column(
        children: <Widget>[
          hsBox20,
          Row(
            children: [
              wsBox10,
              ContainerGradient(
                padding: margin85,
                borderRadius: borderRadius50,
                child: Icon(LucideIcons.layoutDashboard, color: cwhite),
              ),
              wsBox10,
              Text(
                'Welcome! User',
                style: textBoldw700,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          hsBox10,
          Expanded(
            child: Container(
              color: cgrey50,
              child: SingleChildScrollView(
                padding: margin20all,
                child: Column(
                  children: [
                    // hsBox20,
                    // divider,
                    hsBox08,

                    Padding(
                      padding: EdgeInsets.only(bottom: k12),
                      child: AccountPageWidget(
                        title: "Home",

                        icon: Icons.home_outlined,
                        onTap: () {
                          if (web) {
                            pageWeb.nameIndex.value = pageWeb.names.home;
                            return;
                          }
                          NavigatorService.pop();
                          MyPagesController.goToPage(0);
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: k12),
                      child: AccountPageWidget(
                        title: "Category",

                        icon: Icons.category_outlined,
                        onTap: () {
                          if (web) {
                            pageWeb.nameIndex.value = pageWeb.names.category;
                            return;
                          }
                          NavigatorService.pop();
                          MyPagesController.goToPage(1);
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: k12),
                      child: AccountPageWidget(
                        title: "Transaction",

                        icon: Icons.calendar_month,
                        onTap: () {
                          if (web) {
                            pageWeb.nameIndex.value = pageWeb.names.transaction;
                            return;
                          }
                          NavigatorService.pop();
                          MyPagesController.goToPage(2);
                        },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: k12),
                      child: AccountPageWidget(
                        title: "Chart",

                        icon: LucideIcons.chartArea,
                        onTap: () {
                          if (web) {
                            pageWeb.nameIndex.value = pageWeb.names.chart;
                            return;
                          }
                          NavigatorService.pop();
                          MyPagesController.goToPage(3);
                        },
                      ),
                    ),

                    hsBox08,
                    Divider(height: 0.5),
                    hsBox08,

                    Padding(
                      padding: EdgeInsets.only(bottom: k12),
                      child: AccountPageWidget(
                        title: "Change Theme",
                        icon: Icons.dark_mode,
                        onTap: () {
                          // if (web) {
                          //   pageWeb.nameIndex.value = pageWeb.names.category;
                          //   return;
                          // }
                          // NavigatorService.pop();
                          // NavigatorService.push(CategoryListPage());
                        },
                      ),
                    ),

                    hsBox08,
                    Divider(height: 0.5),
                    hsBox08,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerStatus {
  String title = "home";
  void Function(void Function())? ch;
  _DrawerStatus(this.title, this.ch);
}

_DrawerStatus _status = _DrawerStatus("home", null);

class AccountPageWidget extends StatelessWidget {
  const AccountPageWidget({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.trailling,
    this.textColor,
    this.iconWidget,
  });
  final String title;
  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final Widget? trailling;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, ch) {
        final s = _status.title == title;
        if (_status.title == title) {
          _status.ch = ch;
        }
        return InkWell(
          onTap: () {
            _status.title = title;
            _status.ch?.call(() {});
            _status.ch = ch;
            ch.call(() {});
            if (onTap != null) {
              onTap!();
            }
          },
          child: ContainerGradient(
            hideGradient: s ? false : true,
            padding: margin208,
            child: Row(
              children: [
                iconWidget ?? Icon(icon, color: s ? cwhite : textColor),
                wsBox12,
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (textColor == null
                                ? textMediumw500
                                : textMediumw500.fntColor(textColor!))
                            .copyWith(color: s ? cwhite : null),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
