import 'package:expance/core/common.dart';
import 'package:expance/models/model.category.dart';
import 'package:expance/services/local_db/db_models.dart';

class ScreenCategoryPage extends StatefulWidget {
  const ScreenCategoryPage({super.key});

  @override
  State<ScreenCategoryPage> createState() => _ScreenCategoryPageState();
}

class _ScreenCategoryPageState extends State<ScreenCategoryPage> {
  @override
  void dispose() {
    super.dispose();
  }

  addCategory({Category? cate}) async {
    Category d = cate ?? Category();

    g.w.dialog.bottomSheet(
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            hsBox20,
            InputSimple(
              hintText: "Enter Category Name.",
              lable: "Category",
              border: true,
              disposeController: true,
              controller: d.name.tc(),
              onChanged: (dt) => d.name = dt,
              // keyboardType: TextInputType.streetAddress,
            ),
            hsBox15,
            InputSimple(
              hintText: "Enter Category Budget.",
              lable: "Category Budget",
              border: true,
              disposeController: true,
              controller: d.budget?.toString().tc(),
              onChanged: (dt) => d.budget = num.tryParse(dt),
              keyboardType: TextInputType.number,
            ),
            hsBox20,
            ElevatedButtons(
              onPressed: () async {
                if ((d.name ?? '').isEmpty) {
                  showSnackBar("Please Enter Category Name.");
                  return;
                }

                final t = await g.coll.category.getAll(
                  fromJson: g.m.category.fromJson,
                );
                final r = t.any(
                  (e) =>
                      e.name!.trim().toLowerCase() ==
                          d.name!.trim().toLowerCase() &&
                      e.cId != d.cId,
                );
                if (r) {
                  NavigatorService.pop();
                  showSnackBar(
                    "Category Name Already Exists. Please try another name.",
                  );
                  return;
                }

                NavigatorService.pop();
                // printl([d.toJson()]);
                await g.coll.category.set(d.cId!, d);
                setState(() {});
              },
              // child: Text("Add"),
              text: cate == null ? "Add Category" : "Update Category",
            ),
            hsBox10,
          ],
        ),
      ),
      height: 300.fem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Categories")),

      body: Padding(
        padding: margin20all,
        child: FutureBuilderMy(
          future: g.coll.category.getAll(fromJson: g.m.category.fromJson),
          builder: (context, data) {
            return ListViewPaginated(
              data: data,
              itemBuilder: (context, i, d) {
                return Padding(
                  padding: EdgeInsets.only(bottom: k15),
                  child: Stack(
                    children: [
                      g.w.container.cardColor(
                        child: ListTile(
                          title: Text(d.name ?? "No Category Name."),
                          leading: Icon(Icons.category),
                        ),
                      ),
                      Positioned(
                        bottom: k05,
                        right: k05,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: k10,
                          children: [
                            InkWell(
                              onTap: () {
                                addCategory(cate: d);
                              },
                              child: Icon(Icons.edit_calendar_outlined),
                            ),

                            InkWell(
                              onTap: () async {
                                g.w.dialog.deleteAlert(
                                  onDelete: () async {
                                    if (d.cId == null) {
                                      showSnackBar("Id is Null");
                                      return;
                                    }

                                    await g.coll.category.delete(d.cId!);
                                    setState(() {});
                                  },
                                );
                              },
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCategory();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
