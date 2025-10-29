import 'package:expance/controller/controller.home.dart';
import 'package:expance/core/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ScreenChartPage extends StatefulWidget {
  const ScreenChartPage({super.key});

  @override
  State<ScreenChartPage> createState() => _ScreenChartPageState();
}

class _ScreenChartPageState extends State<ScreenChartPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charts"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ContainerShadow(
        padding: margin2010,
        child: Column(
          children: [
            hsBox20,
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
                swapAnimationDuration: const Duration(milliseconds: 1000),
                swapAnimationCurve: Curves.easeOutCubic,
              ),
            ),
            hsBox10,
          ],
        ),
      ),
    );
  }
}
