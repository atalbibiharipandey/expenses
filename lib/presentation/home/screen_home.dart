import 'package:expance/controller/controller.home.dart';
import 'package:expance/core/common.dart';
import 'package:expance/presentation/transactions/screen_add_transactions.dart';
import 'package:fl_chart/fl_chart.dart';

class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage> {
  final cnt = ControllerHome();
  getData() async {
    await cnt.getCurrentMontExpances();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget _textColum(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textNormal.fntSize(14)),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 30),
            child: Column(
              children: [
                ContainerShadow(
                  width: double.infinity,
                  color: cwhite,
                  height: 280.fem,
                  borderRadius: borderRadius20,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "${DateTime.now().format(pattern: "MMMM yyyy")} Expenses",
                            style: textBoldw700,
                          ),
                        ),
                        Divider(),
                        Text("Current Balance", style: textNormal),
                        hsBox08,
                        Text(
                          "${cnt.currentBalance.isNegative ? "- " : ""}${StringUtils.showPrice((cnt.currentBalance.isNegative == true ? (-1 * cnt.currentBalance) : cnt.currentBalance).toStringAsFixed(0))}",
                          style: textBoldw700.fntSize(30),
                        ),
                        hsBox20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textColum(
                              "Income",
                              StringUtils.showPrice(
                                cnt.currentIncome.toStringAsFixed(0),
                              ),
                              Colors.greenAccent,
                            ),
                            _textColum(
                              "Expense",
                              StringUtils.showPrice(
                                cnt.currentExpenses.toStringAsFixed(0),
                              ),
                              Colors.redAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                hsBox30,

                ContainerShadow(
                  padding: margin2010,
                  child: Column(
                    children: [
                      Text(
                        "${DateTime.now().format(pattern: "MMMM yyyy")} Expense Breakdown Chart",
                        style: textBoldw700.fntSize(18),
                      ),

                      hsBox20,
                      SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: 270,
                            sectionsSpace: 3,
                            centerSpaceRadius: 45,
                            pieTouchData: PieTouchData(enabled: true),
                            sections: cnt.categoryTotals.entries.map((e) {
                              final color = getRandomColor();
                              return PieChartSectionData(
                                color: color,
                                value: e.value,
                                radius: 70,
                                title:
                                    "${e.key}\n${((e.value / (cnt.currentExpenses)) * 100).toStringAsFixed(1)}%",
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList(),
                          ),
                          swapAnimationDuration: const Duration(
                            milliseconds: 1000,
                          ),
                          swapAnimationCurve: Curves.easeOutCubic,
                        ),
                      ),
                      hsBox10,
                    ],
                  ),
                ),

                hsBox30,

                // 🧾 Recent Transactions
                ContainerShadow(
                  padding: margin2010,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Transactions",
                        style: textBoldw700.fntSize(18),
                      ),

                      hsBox12,
                      ...cnt.transaction.take(5).map((t) {
                        final bool isIncome = t.income ?? false;
                        return Padding(
                          padding: EdgeInsets.only(bottom: k10),
                          child: g.w.container.cardColor(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isIncome
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                child: Icon(
                                  LucideIcons.history,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(t.name ?? "No Data"),
                              trailing: Text(
                                (isIncome ? '+ ' : '- ') +
                                    "${StringUtils.showPrice(t.amount?.toStringAsFixed(0))}",
                                style: textBoldw700.fntColor(
                                  isIncome
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    t.category ?? '',
                                    style: textMediumw500.fntColor(cgrey600),
                                  ),
                                  Text(
                                    t.date?.format(pattern: "dd MMM yyyy") ??
                                        '',
                                    style: textMediumw500.fntColor(cgrey600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigatorService.push(ScreenTransactionsAddPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
