import 'package:expance/core/common.dart';

class DialogWidget {
  Future<dynamic> bottomSheet(Widget child, {double? height}) {
    final context =
        (NavigatorService.navigatorKeySecond).currentContext ??
        NavigatorService.navigatorKey.currentContext;
    return showModalBottomSheet(
      context: context!,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            width: double.maxFinite,
            height: height ?? MediaQuery.of(context).size.height / 2,
            padding: EdgeInsets.symmetric(horizontal: k20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: child,
          ),
        );
      },
    );
  }

  deleteAlert({String? title, String? message, VoidCallback? onDelete}) async {
    final t = await MyDialogUtils.showAlert(
      title: title ?? "Are You Sure?",
      message: message ?? "Are You Sure Want to Delete this?",
    );
    print(t);
    if (t ?? false) {
      if (onDelete != null) {
        onDelete();
      }
    }
  }
}
