// shared_prefs_firestore.dart

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// manual collection Name

// SharedPreferences? prefsBack;

/// Abstract model base class
abstract class BaseModel {
  Map<String, dynamic> toJson();
  // String get cId;
  // BaseModel create({BaseModel? data});
  // BaseModel fromJson(Map<String, dynamic> json);
}

/// Singleton SharedPrefsDatabase
///

class LocalDb {
  static final LocalDb _instance = LocalDb._internal();
  factory LocalDb() => _instance;
  LocalDb._internal();

  static SharedPreferences? _prefs;
  final Map<String, CollectionRef> _collections = {};

  /// Initialize SharedPreferences once
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Access to SharedPreferences
  static SharedPreferences get prefs {
    // print(_prefs);
    // print(prefsBack);

    assert(_prefs != null, 'Call SharedPrefsDatabase.initialize() first.');
    return _prefs!;
  }

  /// Get a collection by name
  CollectionRef<T> collection<T extends BaseModel>(String name) {
    return _collections.putIfAbsent(name, () => CollectionRef<T>(name))
        as CollectionRef<T>;
  }

  /// Export entire DB as JSON string
  String exportDB() {
    final allData = prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
      map[key] = prefs.getString(key);
      return map;
    });
    return jsonEncode(allData);
  }

  /// Import JSON string into DB (clears existing data)
  Future<void> importDB(String jsonString) async {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    await prefs.clear();
    for (final entry in data.entries) {
      await prefs.setString(entry.key, entry.value);
    }
    // Notify all collections
    for (final collection in _collections.values) {
      await collection._notifyListeners();
    }
    // await relaodIsolateDb();
  }
}

/// Collection-level reference class
class CollectionRef<T extends BaseModel> {
  final String name;
  StreamController<List<T>>? _streamController;

  CollectionRef(this.name);

  String _docKey(String id) => '$name:$id';

  /// Set or update document
  Future<void> set(String id, T model) async {
    await LocalDb.prefs.setString(_docKey(id), jsonEncode(model.toJson()));
    // await relaodIsolateDb();
    _notifyListeners();
  }

  /// id necessary he nahi to document ko delete ya update nahi kar Sakate...
  Future<String?> add(String? id, T model) async {
    if (id != null) {
      final s = LocalDb.prefs.containsKey(id.toString());
      if (s) {
        return null;
      }
    } else {
      await Future.delayed(Duration(milliseconds: 1));
      id ??= DateTime.now().millisecondsSinceEpoch.toString();
    }
    await set(id.toString(), model);
    return id.toString();
  }

  /// Get document by id
  Future<T?> get(String id, T Function(Map<String, dynamic>) fromJson) async {
    // final t = await isolate.run<T?>((
    //   String id,
    //   T Function(Map<String, dynamic>) fromJson,
    // ) {
    //   final jsonString = prefsBack!.getString(id);
    //   if (jsonString == null) return null;
    //   return fromJson(jsonDecode(jsonString));
    // }, args: [_docKey(id), fromJson]);
    // return t;
    final jsonString = LocalDb.prefs.getString(_docKey(id));
    if (jsonString == null) return null;
    return fromJson(jsonDecode(jsonString));
  }

  /// Delete document by id
  Future<void> delete(String id) async {
    await LocalDb.prefs.remove(_docKey(id));
    // await relaodIsolateDb();
    _notifyListeners();
  }

  /// Get all documents with optional filtering, ordering, and pagination
  Future<List<MapEntry<String, T>>> getAllWithIds({
    required T Function(Map<String, dynamic>) fromJson,
    bool Function(T)? where,
    int Function(T, T)? orderBy,
    int? limit,
    int offset = 0,
  }) async {
    // final t = await isolate.run<List<MapEntry<String, T>>>((
    //   T Function(Map<String, dynamic>) fromJson,
    //   bool Function(T)? where,
    //   int Function(T, T)? orderBy,
    //   int? limit,
    //   int offset,
    //   String name,
    // ) {
    //   final keys = prefsBack!.getKeys().where(
    //     (key) => key.startsWith('$name:'),
    //   );

    //   List<MapEntry<String, T>> docs = [];
    //   for (final key in keys) {
    //     final jsonString = prefsBack!.getString(key);
    //     if (jsonString != null) {
    //       final model = fromJson(jsonDecode(jsonString));
    //       docs.add(MapEntry(key.split(':').last, model));
    //     }
    //   }

    //   if (where != null) {
    //     docs = docs.where((entry) => where(entry.value)).toList();
    //   }
    //   if (orderBy != null) {
    //     docs.sort((a, b) => orderBy(a.value, b.value));
    //   }
    //   if (offset > 0) {
    //     docs = docs.skip(offset).toList();
    //   }
    //   if (limit != null) {
    //     docs = docs.take(limit).toList();
    //   }

    //   return docs;
    // }, args: [fromJson, where, orderBy, limit, offset, name]);
    // return t;
    final keys = LocalDb.prefs.getKeys().where(
      (key) => key.startsWith('$name:'),
    );

    List<MapEntry<String, T>> docs = [];
    for (final key in keys) {
      final jsonString = LocalDb.prefs.getString(key);
      if (jsonString != null) {
        final model = fromJson(jsonDecode(jsonString));
        docs.add(MapEntry(key.split(':').last, model));
      }
    }

    if (where != null) {
      docs = docs.where((entry) => where(entry.value)).toList();
    }
    if (orderBy != null) {
      docs.sort((a, b) => orderBy(a.value, b.value));
    }
    if (offset > 0) {
      docs = docs.skip(offset).toList();
    }
    if (limit != null) {
      docs = docs.take(limit).toList();
    }

    return docs;
  }

  /// Get all documents with optional filtering, ordering, and pagination
  Future<List<T>> getAll({
    required T Function(Map<String, dynamic>) fromJson,
    bool Function(T)? where,
    int Function(T, T)? orderBy,
    int? limit,
    int offset = 0,
  }) async {
    final keys = LocalDb.prefs.getKeys().where(
      (key) => key.startsWith('$name:'),
    );

    List<T> models = [];
    for (final key in keys) {
      final jsonString = LocalDb.prefs.getString(key);
      if (jsonString != null) {
        final model = fromJson(jsonDecode(jsonString));
        models.add(model);
      }
    }

    if (where != null) {
      models = models.where(where).toList();
    }
    if (orderBy != null) {
      models.sort(orderBy);
    }
    if (offset > 0) {
      models = models.skip(offset).toList();
    }
    if (limit != null) {
      models = models.take(limit).toList();
    }

    return models;
  }

  /// Watch collection in realtime (lazy stream)
  Stream<List<T>> stream({
    required T Function(Map<String, dynamic>) fromJson,
    bool Function(T)? where,
    int Function(T, T)? orderBy,
    int? limit,
    int offset = 0,
  }) {
    _streamController ??= StreamController<List<T>>.broadcast(
      onListen: () => _notifyListeners(
        fromJson: fromJson,
        where: where,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      ),
    );
    return _streamController!.stream;
  }

  /// Watch single document by id
  Stream<T?> docStream(String id, T Function(Map<String, dynamic>) fromJson) {
    final controller = StreamController<T?>.broadcast();
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final doc = await get(id, fromJson);
      controller.add(doc);
    });
    return controller.stream;
  }

  /// Query builder
  QueryBuilder<T> query() => QueryBuilder<T>(this);

  /// Export all documents in this collection
  Future<String> exportCollection() async {
    final keys = LocalDb.prefs.getKeys().where((k) => k.startsWith('$name:'));
    final map = <String, String>{};
    for (final key in keys) {
      final value = LocalDb.prefs.getString(key);
      if (value != null) map[key] = value;
    }
    return jsonEncode(map);
  }

  /// Import documents into this collection
  Future<void> importCollection(String jsonString) async {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    for (final entry in data.entries) {
      await LocalDb.prefs.setString(entry.key, entry.value);
    }
    await _notifyListeners();
  }

  /// Notify listeners of changes
  Future<void> _notifyListeners({
    T Function(Map<String, dynamic>)? fromJson,
    bool Function(T)? where,
    int Function(T, T)? orderBy,
    int? limit,
    int offset = 0,
  }) async {
    if (_streamController == null ||
        !_streamController!.hasListener ||
        fromJson == null) {
      return;
    }
    final data = await getAll(
      fromJson: fromJson,
      where: where,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    _streamController!.add(data);
  }
}

/// Query-like chaining support with compound filter & pagination

@pragma('vm:entry-point')
class QueryBuilder<T extends BaseModel> {
  final CollectionRef<T> ref;
  final List<bool Function(T)> _filters = [];
  int Function(T a, T b)? _orderBy;
  int? _limit;
  int _offset = 0;

  QueryBuilder(this.ref);

  /// Add filter
  QueryBuilder<T> where(bool Function(T) test) {
    _filters.add(test);
    return this;
  }

  /// Add ordering
  QueryBuilder<T> orderBy(int Function(T a, T b) compare) {
    _orderBy = compare;
    return this;
  }

  /// Set limit
  QueryBuilder<T> limit(int value) {
    _limit = value;
    return this;
  }

  /// Set offset
  QueryBuilder<T> offset(int value) {
    _offset = value;
    return this;
  }

  /// Fetch filtered/sorted/paginated results
  Future<List<T>> get({
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    return await ref.getAll(
      fromJson: fromJson,
      where: _composeFilters(),
      orderBy: _orderBy,
      limit: _limit,
      offset: _offset,
    );
  }

  /// Stream filtered/sorted/paginated results
  Stream<List<T>> stream({required T Function(Map<String, dynamic>) fromJson}) {
    return ref.stream(
      fromJson: fromJson,
      where: _composeFilters(),
      orderBy: _orderBy,
      limit: _limit,
      offset: _offset,
    );
  }

  bool Function(T)? _composeFilters() {
    if (_filters.isEmpty) return null;
    return (T model) => _filters.every((test) => test(model));
  }
}

// ... existing imports and code above

extension CollectionExportImport<T extends BaseModel> on CollectionRef<T> {
  /// Export this collection to a Map<String, dynamic>
  Future<Map<String, dynamic>> toMap() async {
    final keys = LocalDb.prefs.getKeys().where(
      (key) => key.startsWith('$name:'),
    );
    final map = <String, dynamic>{};
    for (final key in keys) {
      final jsonString = LocalDb.prefs.getString(key);
      if (jsonString != null) {
        final id = key.split(':').last;
        map[id] = jsonDecode(jsonString);
      }
    }
    return map;
  }

  /// Import data from Map<String, dynamic> into this collection
  Future<void> fromMap(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final key = _docKey(entry.key);
      await LocalDb.prefs.setString(key, jsonEncode(entry.value));
    }
    await _notifyListeners();
  }

  /// Export this collection as JSON string
  Future<String> exportAsJson() async {
    final map = await toMap();
    return jsonEncode(map);
  }

  /// Import this collection from JSON string
  Future<void> importFromJson(String json) async {
    final map = jsonDecode(json) as Map<String, dynamic>;
    await fromMap(map);
  }
}




// 🔧 Setup
// First, initialize the shared preferences before using the database:
 
// await SharedPrefsDatabase.initialize();
// final db = SharedPrefsDatabase();
// final users = db.collection<UserModel>('users');

// ✨ Add a User (Auto-generated ID) 
// await users.add(UserModel(id: '', name: 'Alice', age: 25));

// ✨ Add/Update a User (Manually set ID)
// await users.set('user123', UserModel(id: 'user123', name: 'Bob', age: 30));

// 🔍 Get a User by ID
// final user = await users.get('user123', UserModel.fromJson);
// print(user?.name); // Output: Bob

// 📋 Get All Users
// final allUsers = await users.getAll(fromJson: UserModel.fromJson);

// 🔎 Filtered & Ordered Query (Like Firestore!)
// final results = await users.query()
//   .where((u) => u.age > 18)
//   .orderBy((a, b) => a.age.compareTo(b.age))
//   .limit(5)
//   .offset(1)
//   .get(fromJson: UserModel.fromJson);

// 🔁 Stream All Users
// users.stream(fromJson: UserModel.fromJson).listen((userList) {
//   print('Updated user list: ${userList.map((u) => u.name)}');
// });

// 👤 Stream Single User
// users.docStream('user123', UserModel.fromJson).listen((user) {
//   print('User updated: ${user?.name}');
// });

// 🔁 Export & Import DB
// final jsonExport = db.exportDB();
// Save/export jsonExport somewhere
// await db.importDB(jsonExport); // Import it later

// 📁 Export & Import a Single Collection
// final collectionJson = await users.exportCollection();
// await users.importCollection(collectionJson);
