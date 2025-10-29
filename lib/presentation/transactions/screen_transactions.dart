import 'package:expance/core/common.dart';
import 'package:expance/presentation/transactions/screen_add_transactions.dart';

class ScreenTransactionsPage extends StatefulWidget {
  const ScreenTransactionsPage({super.key});

  @override
  State<ScreenTransactionsPage> createState() => _ScreenTransactionsPageState();
}

class _ScreenTransactionsPageState extends State<ScreenTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: margin20all,
        child: FutureBuilderMy(
          future: g.coll.transaction.getAll(fromJson: g.m.transaction.fromJson),
          builder: (context, data) {
            return ListViewPaginated(
              data: data,
              itemBuilder: (context, i, d) {
                return Dismissible(
                  key: Key(d.tId!),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) async {
                    await g.coll.transaction.delete(d.tId!);
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: k15),
                    child: Stack(
                      children: [
                        g.w.container.cardColor(
                          child: ListTile(
                            onTap: () async {
                              final t = await NavigatorService.push(
                                ScreenTransactionsAddPage(data: d),
                              );
                              if (t == true) {
                                setState(() {});
                              }
                            },
                            title: Text(d.name ?? "No Name."),
                            leading: Icon(LucideIcons.history),
                            trailing: Text(
                              StringUtils.showPrice(
                                d.amount?.toStringAsFixed(0) ?? '',
                              ),
                              style: textBoldw700.fntColor(
                                d.income == true ? cGreen : cred,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  d.category ?? '',
                                  style: textMediumw500.fntColor(cgrey600),
                                ),
                                Text(
                                  d.date?.format(pattern: "dd MMM yyyy") ?? '',
                                  style: textMediumw500.fntColor(cgrey600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final t = await NavigatorService.push(ScreenTransactionsAddPage());
          if (t == true) {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
