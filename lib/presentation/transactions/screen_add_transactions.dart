import 'package:expance/core/common.dart';
import 'package:expance/models/model.category.dart';
import 'package:expance/models/model.transaction.dart';

class ScreenTransactionsAddPage extends StatefulWidget {
  const ScreenTransactionsAddPage({super.key, this.data});
  final Transaction? data;

  @override
  State<ScreenTransactionsAddPage> createState() =>
      _ScreenTransactionsAddPageState();
}

class _ScreenTransactionsAddPageState extends State<ScreenTransactionsAddPage> {
  List<Category>? category;
  Transaction? data;
  final key = GlobalKey<FormState>();
  final cDay = DateTime.now();
  ValueNotifier<num?> catAmount = ValueNotifier(null);
  num? catbudget;
  @override
  void initState() {
    super.initState();
    data = widget.data ?? Transaction();
  }

  Future<List<InputValue<Category>>> getCategoryData() async {
    category ??= await g.coll.category.getAll(fromJson: g.m.category.fromJson);
    final cat = category!
        .map((e) => InputValue<Category>(e.name!.trim(), value: e))
        .toList();
    return cat;
  }

  totalCateogrySpend(String? cate) async {
    num tmp = 0;
    final res = await g.coll.transaction.getAll(
      fromJson: g.m.transaction.fromJson,
      where: (p0) =>
          p0.category == cate &&
          p0.date?.format(pattern: "MM/yyyy") ==
              cDay.format(pattern: "MM/yyyy"),
    );
    for (var e in res) {
      if (e.income != true) {
        tmp = tmp + (e.amount ?? 0);
      }
    }

    if (tmp > (catbudget ?? 0)) {
      catAmount.value = tmp;
    } else {
      catAmount.value = null;
    }
    if (catbudget != null && catbudget != 0) {
      final t = tmp / catbudget!;
      if (t >= 8.5 && t < 10) {
        showSnackBar(
          "Reaching to Category Budget ${StringUtils.showPrice(catbudget?.toStringAsFixed(0))}, Total Current Amount: ${StringUtils.showPrice(tmp.toStringAsFixed(0))}",
        );
      }
    }
  }

  @override
  void dispose() {
    key.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data == null ? "Add Transaction" : "Update Transaction",
        ),
      ),
      body: SingleChildScrollView(
        padding: margin20rtb10,
        child: Form(
          key: key,
          child: Column(
            children: [
              SizedBox(width: double.maxFinite, height: k10),
              SizedBox(
                width: webWidht,
                child: InputSimple(
                  hintText: "Select Expense Category.",
                  lable: "Expense Category",
                  border: true,
                  disposeController: true,
                  controller: data?.category?.tc(),
                  onSelect: (v) {
                    data?.category = v.text;
                    catbudget = v.value.budget;
                    totalCateogrySpend(data?.category);
                  },
                  dropdownButton: true,
                  dropdownData: getCategoryData(),
                  suggestionRequired: true,
                  suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: catAmount,
                builder: (context, value, child) {
                  if (value == null) {
                    return noWidget;
                  }
                  return Text(
                    "Overflow ${data?.category} Budget: ${StringUtils.showPrice(catbudget?.toStringAsFixed(0))}, ${data?.category} Expenses: ${StringUtils.showPrice(catAmount.value?.toStringAsFixed(0))}",
                    style: textNormal.fntColor(cred),
                  );
                },
              ),
              hsBox15,
              InputSimple(
                hintText: "Enter Transaction Name.",
                lable: "Transaction Name",
                border: true,
                disposeController: true,
                controller: data?.name.tc(),
                onChanged: (dt) => data?.name = dt,
              ),
              hsBox15,
              InputSimple(
                hintText: "Enter Transaction Amount.",
                lable: "Transaction Amount",
                border: true,
                disposeController: true,
                controller: data?.amount?.toString().tc(),
                onChanged: (dt) => data?.amount = num.tryParse(dt),
                keyboardType: TextInputType.number,
              ),
              hsBox15,
              SizedBox(
                width: webWidht,
                child: StatefulBuilder(
                  builder: (context, st) {
                    return CheckboxListTile.adaptive(
                      value: data?.income ?? false,
                      onChanged: (v) {
                        data?.income = v;
                        st(() {});
                      },
                      title: Text(
                        "Income",
                        style: textBoldw700.fntColor(cGreen),
                      ),
                    );
                  },
                ),
              ),
              hsBox20,
              ElevatedButtons(
                width: webWidht,
                onPressed: () async {
                  if (key.currentState?.validate() == false) {
                    return;
                  }

                  await g.coll.transaction.set(data!.tId!, data!);
                  NavigatorService.pop(result: true);
                  showSnackBar("Transaction Addedd Successfully");
                },
                // child: Text("Add"),
                text: widget.data == null
                    ? "Add Transaction"
                    : "Update Transaction",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
