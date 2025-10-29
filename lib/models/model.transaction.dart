import 'package:expance/core/common.dart';
import 'package:expance/models/model.paginate.dart';
import 'package:expance/services/local_db/local_db.dart';

class Transaction extends BaseModel {
  String? tId;
  int? id;
  String? imgUrl;
  String? captureText;
  int? productive; // Default false in Prisma
  int? unProductive; // Default 0 in Prisma
  int? ideal; // Default 0 in Prisma

  int? clockInOutId;
  int? sessionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? salary;
  int? workTime;
  int? monthsId;

  Transaction({
    this.tId,
    this.id,
    this.imgUrl,
    this.captureText,
    this.productive,
    this.unProductive,
    this.ideal,

    this.sessionId,
    this.createdAt,
    this.updatedAt,
    this.salary,
    this.clockInOutId,

    this.workTime,
    this.monthsId,
  }) {
    tId ??= DateTime.now().millisecondsSinceEpoch.toString();
  }

  Transaction create({Transaction? data}) => data ?? Transaction();

  Transaction fromJson(Map<String, dynamic> json) => Transaction.fromJson(json);

  static ModelPaginate<Transaction> paginate(Map<String, dynamic> json) =>
      ModelPaginate<Transaction>.fromJson(
        json,
        (p0) => Transaction.fromJson(p0),
      );
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      tId: json['tId'],
      id: json['id'],
      imgUrl: json['imgUrl'],
      captureText: json['captureText'],
      productive: json['productive'],
      unProductive: json['unProductive'],
      ideal: json['ideal'],
      salary: 0,
      clockInOutId: json['clockInOutId'],
      workTime: 0,
      monthsId: json['monthsId'],

      sessionId: json['sessionId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tId': tId,
      'id': id,
      if (imgUrl != null && imgUrl!.isNotEmpty) 'imgUrl': imgUrl,
      'captureText': captureText,
      if (productive != null) 'productive': productive,
      if (unProductive != null) 'unProductive': unProductive,
      if (ideal != null) 'ideal': ideal,

      'sessionId': sessionId,
      'salary': salary,
      "workTime": workTime,
      "monthsId": monthsId,
      "clockInOutId": clockInOutId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      'updatedAt':
          updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}
