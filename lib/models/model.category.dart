import 'package:expance/models/model.paginate.dart';
import 'package:expance/services/local_db/local_db.dart';

class Category extends BaseModel {
  String? cId;
  String? name;
  num? budget;

  Category({this.cId, this.name, this.budget}) {
    cId ??= DateTime.now().millisecondsSinceEpoch.toString();
  }

  Category create({Category? data}) => data ?? Category();

  Category fromJson(Map<String, dynamic> json) => Category.fromJson(json);

  static ModelPaginate<Category> paginate(Map<String, dynamic> json) =>
      ModelPaginate<Category>.fromJson(json, (p0) => Category.fromJson(p0));

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      cId: json['id'],
      name: json['name'],
      budget: json['budget'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': cId, 'name': name, 'budget': budget};
  }
}
