import 'package:expance/core/common.dart';
import 'package:fl_chart/fl_chart.dart';

class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage> {
  final double income = 12000;
  final double expenses = 4800;

  final List<Map<String, dynamic>> recentTransactions = [
    {
      'category': 'Food',
      'amount': 500,
      'type': 'Expense',
      'icon': Icons.fastfood,
    },
    {
      'category': 'Salary',
      'amount': 12000,
      'type': 'Income',
      'icon': Icons.work,
    },
    {
      'category': 'Shopping',
      'amount': 1500,
      'type': 'Expense',
      'icon': Icons.shopping_bag,
    },
    {
      'category': 'Bills',
      'amount': 800,
      'type': 'Expense',
      'icon': Icons.receipt_long,
    },
    {
      'category': 'Transport',
      'amount': 700,
      'type': 'Expense',
      'icon': Icons.directions_car,
    },
  ];

  Map<String, double> get categoryTotals => {
    'Food': 500,
    'Shopping': 1500,
    'Bills': 800,
    'Transport': 700,
  };
  Widget _textColum(String title, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textNormal.fntSize(14)),
        const SizedBox(height: 4),
        Text(
          "₹${amount.toStringAsFixed(2)}",
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
    final double balance = income - expenses;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("Dashboard"), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 30),
            child: Column(
              children: [
                ContainerShadow(
                  width: double.infinity,
                  color: cwhite,
                  height: 240.fem,
                  borderRadius: borderRadius20,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Balance", style: textNormal),
                        hsBox08,
                        Text(
                          "₹${balance.toStringAsFixed(2)}",
                          style: textBoldw700.fntSize(30),
                        ),
                        hsBox20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _textColum("Income", income, Colors.greenAccent),
                            _textColum("Expense", expenses, Colors.redAccent),
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
                      const Text(
                        "Expense Breakdown",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                            sections: categoryTotals.entries.map((e) {
                              final color = getRandomColor();
                              return PieChartSectionData(
                                color: color,
                                value: e.value,
                                radius: 70,
                                title:
                                    "${e.key}\n${((e.value / expenses) * 100).toStringAsFixed(1)}%",
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
                      const Text(
                        "Recent Transactions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...recentTransactions.map((t) {
                        final bool isIncome = t['type'] == 'Income';
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            child: Icon(t['icon'], color: Colors.white),
                          ),
                          title: Text(t['category']),
                          trailing: Text(
                            (isIncome ? '+' : '-') + "₹${t['amount']}",
                            style: TextStyle(
                              color: isIncome
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
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
        onPressed: () {},
        backgroundColor: Colors.tealAccent[400],
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
