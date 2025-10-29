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
      body: Form(
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
                },
                dropdownButton: true,
                dropdownData: getCategoryData(),
                suggestionRequired: true,
                suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
              ),
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
                    title: Text("Income", style: textBoldw700.fntColor(cGreen)),
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
    );
  }
}
