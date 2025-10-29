import 'package:expance/models/model.category.dart';
import 'package:expance/models/model.transaction.dart';
import 'package:expance/services/local_db/local_db.dart';

final coll = (categories: "categories", transaction: "transaction");

initializeLocalDatabase() async {
  await LocalDb.initialize();
  LocalDb().collection<Category>(coll.categories);
  LocalDb().collection<Transaction>(coll.transaction);
}

class Collection {
  final category = LocalDb().collection<Category>(coll.categories);
  final transaction = LocalDb().collection<Transaction>(coll.transaction);
}

class Model {
  final category = Category();
  final transaction = Transaction();
}
