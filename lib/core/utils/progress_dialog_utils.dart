import 'package:expance/core/common.dart';

class MyDialogUtils {
  static bool isProgressVisible = false;

  static Future<dynamic> showBottomSheete(
    Widget widget, {
    BuildContext? context,
    isCancellable = false,
    AnimationController? transitionAnimationController,
    bool? enableDrag,
    ShapeBorder? shape,
    double? elevation,
    Color? backgroundColor,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    bool? isScrollControlled,
  }) async {
    //NavigatorService.backToDialog();
    if (!isProgressVisible &&
        NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      isProgressVisible = true;
      return await showModalBottomSheet(
        backgroundColor: backgroundColor,
        clipBehavior: clipBehavior,
        constraints: constraints,
        elevation: elevation,
        enableDrag: enableDrag ?? false,
        shape: shape,
        isDismissible: false,
        isScrollControlled: isScrollControlled ?? false,
        transitionAnimationController: transitionAnimationController,
        context:
            context ??
            NavigatorService.navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              isProgressVisible = false;
              print("Dialog is closed..");
              return true;
            },
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: widget,
            ),
          );
        },
      );
    } else {
      showSnackBar("Dialog is Already Opened........");
    }
  }

  static Future<dynamic> showDialoge(
    Widget widget, {
    BuildContext? context,
    isCancellable = false,
  }) async {
    if (!isProgressVisible &&
        NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      isProgressVisible = true;
      return await showDialog(
        barrierDismissible: isCancellable,
        context:
            context ??
            NavigatorService.navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              isProgressVisible = false;
              return true;
            },
            child: widget,
          );
        },
      );
    } else {
      showSnackBar("Dialog is Already Opened........");
    }
  }

  ///common method for showing progress dialog
  static void showProgressDialog({
    BuildContext? context,
    isCancellable = false,
  }) async {
    if (!isProgressVisible &&
        NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      showDialog(
        barrierDismissible: isCancellable,
        context:
            context ??
            NavigatorService.navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              isProgressVisible = false;
              return true;
            },
            child: const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) {
      Navigator.pop(
        NavigatorService.navigatorKey.currentState!.overlay!.context,
      );
      isProgressVisible = false;
    }
  }

  static Future<bool?> deleteAlert({
    BuildContext? context,
    isCancellable = false,
    String? status,
  }) async {
    bool? tmp;
    // hideProgressDialog();
    if (NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      tmp = await showDialog(
        barrierDismissible: isCancellable,
        context: NavigatorService.navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: Text(
              "Are you sure want to delete ${status ?? 'this'}.",
              style: TextStyle(color: cBodyText),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    NavigatorService
                        .navigatorKey
                        .currentState!
                        .overlay!
                        .context,
                    true,
                  );
                  //isProgressVisible = false;
                },
                child: Text("Yes", style: TextStyle(color: Colors.white)),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    NavigatorService
                        .navigatorKey
                        .currentState!
                        .overlay!
                        .context,
                    false,
                  );
                },
                child: Text("Back"),
              ),
            ],
          );
        },
      );
      // isProgressVisible = true;
    }
    if (tmp != null) {
      return tmp;
    } else {
      return tmp;
    }
  }

  static Future<bool?> showAlert({
    BuildContext? context,
    isCancellable = false,
    String? message,
    String? title,
  }) async {
    bool? tmp;
    // hideProgressDialog();
    if (NavigatorService.navigatorKey.currentState?.overlay?.context != null) {
      tmp = await showDialog(
        barrierDismissible: isCancellable,
        context: NavigatorService.navigatorKey.currentState!.overlay!.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? "Info"),
            content: Text(message ?? ''),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    NavigatorService
                        .navigatorKey
                        .currentState!
                        .overlay!
                        .context,
                    true,
                  );
                  //isProgressVisible = false;
                },
                child: Text("Ok"),
              ),
              OutlinedButton(
                onPressed: () {
                  // hideProgressDialog();
                  NavigatorService.pop();
                },
                child: Text("Back"),
              ),
            ],
          );
        },
      );
      // isProgressVisible = true;
    }
    if (tmp != null) {
      return tmp;
    } else {
      return tmp;
    }
  }

  static Future<dynamic> showDialoges(Widget? widget) async {
    final t = await NavigatorService.push(
      GoToDialogScreen(widget: widget ?? SizedBox.shrink()),
    );
    return t;
  }
}

class GoToDialogScreen extends StatelessWidget {
  const GoToDialogScreen({super.key, required this.widget});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withAlpha(80),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              print("OnClicked.... Outside...");
              // MyDialogUtils.hideProgressDialog();
              NavigatorService.pop();
            },
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: ctransparent,
              child: Column(mainAxisSize: MainAxisSize.max, children: []),
            ),
          ),
          Container(
            margin: margin20all,
            decoration: BoxDecoration(
              borderRadius: borderRadius10,
              color: cwhite,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      // MyDialogUtils.hideProgressDialog();
                      NavigatorService.pop();
                    },
                    icon: Icon(Icons.close, color: Colors.red),
                  ),
                ),
                Padding(padding: margin20all, child: widget),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
