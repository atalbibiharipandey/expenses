import 'dart:async';

import 'package:expance/core/common.dart';
import 'package:expance/core/utils/progress_dialog_utils.dart';
import 'package:expance/core/utils/transition/src/enum.dart';
import 'package:expance/core/utils/transition/src/page_transition.dart';

const transitionType = PageTransitionType.rightToLeftWithFade;

class NavigatorService<T> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> navigatorKeySecond =
      GlobalKey<NavigatorState>();

  static StreamController<int> popCount = StreamController.broadcast();

  static Future<dynamic> pushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static void pop({result}) {
    if (MyDialogUtils.isProgressVisible) {
      MyDialogUtils.isProgressVisible = false;
    }
    // popCount.add(-1);
    return (navigatorKeySecond.currentState ?? navigatorKey.currentState)?.pop(
      result,
    );
  }

  static void backToDialog() {
    if (MyDialogUtils.isProgressVisible) {
      MyDialogUtils.isProgressVisible = false;
      return navigatorKey.currentState?.pop();
    }
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    bool routePredicate = false,
    dynamic arguments,
  }) async {
    return (navigatorKeySecond.currentState ?? navigatorKey.currentState)
        ?.pushNamedAndRemoveUntil(
          routeName,
          (route) => routePredicate,
          arguments: arguments,
        );
  }

  static Future<dynamic> popAndPushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    if (MyDialogUtils.isProgressVisible) {
      MyDialogUtils.isProgressVisible = false;
    }
    return navigatorKey.currentState?.popAndPushNamed(
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> push(classes) async {
    final t =
        (navigatorKeySecond.currentContext ?? navigatorKey.currentContext);
    if (t != null) {
      // popCount.add(1);
      return await Navigator.push(
        t,
        PageTransition(
          child: classes,
          ctx: t,
          type: transitionType,
          reverseDuration: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 250),
          isIos: true,
        ),
      );
    } else {
      showSnackBar("${classes.toString()}, Context Not Found.");
      return null;
    }
  }

  static pushReplacement(classes) {
    final t =
        (navigatorKeySecond.currentContext ?? navigatorKey.currentContext);
    if (t != null) {
      Navigator.pushReplacement(
        t,
        PageTransition(
          child: classes,
          ctx: t,
          type: transitionType,
          reverseDuration: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 250),
          isIos: true,
        ),
      );
    } else {
      showSnackBar("${classes.toString()}, Context Not Found.");
    }
  }

  static pushAndRemoveUntil(classes) {
    final t =
        (navigatorKeySecond.currentContext ?? navigatorKey.currentContext);
    if (t != null) {
      if (MyDialogUtils.isProgressVisible) {
        MyDialogUtils.isProgressVisible = false;
      }
      Navigator.pushAndRemoveUntil(
        t,
        PageTransition(
          child: classes,
          ctx: t,
          type: transitionType,
          reverseDuration: const Duration(milliseconds: 250),
          duration: const Duration(milliseconds: 250),
          isIos: true,
        ),
        (route) => false,
      );
    } else {
      showSnackBar("${classes.toString()}, Context Not Found.");
    }
  }

  static popRootNavigatorTrue(classes) {
    final t =
        (navigatorKeySecond.currentContext ?? navigatorKey.currentContext);

    if (t != null) {
      if (MyDialogUtils.isProgressVisible) {
        MyDialogUtils.isProgressVisible = false;
      }
      Navigator.of(t, rootNavigator: true).pop();
    } else {
      showSnackBar("Context Not Found.");
    }
  }
}

// Define the type for the onWillPop callback
typedef WillPop = Future<bool> Function();

// GlobalKey for NavigatorState (useful for showing dialogs from non-BuildContext
// e.g., if the onWillPop logic involves showing a dialog)
/// A custom `WillPopScope`-like widget that leverages `PopScope`
/// to control pop behavior for both system back gestures and
/// the default `AppBar` back button.
///
/// **Crucial Usage Note:** To make this work correctly with the `AppBar`'s
/// default back button (which simply calls `Navigator.pop()`), this widget
/// (or a `PopScope` directly) **must be placed at the root of the `ModalRoute`**
/// (e.g., as the top-level widget in a `MaterialPageRoute`'s builder function).
class WillPopScopes extends StatefulWidget {
  const WillPopScopes({super.key, required this.child, required this.willPop});

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called to veto attempts by the user to dismiss the enclosing [ModalRoute].
  ///
  /// If the callback returns a Future that resolves to `false`, the enclosing
  /// route will not be popped.
  final WillPop willPop;

  @override
  State<WillPopScopes> createState() => _WillPopScopesState();
}

class _WillPopScopesState extends State<WillPopScopes> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents the default pop behavior
      // Using onPopInvokedWithResult as onPopInvoked is deprecated.
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        // 'didPop' is true if a pop was already handled by a PopScope higher up
        // in the widget tree, or if the system decided to pop regardless.
        if (result == true) {
          return;
        }

        // Call the user-provided onWillPop callback to determine if pop should proceed
        final bool shouldPop = await widget.willPop();
        await Future.delayed(const Duration(milliseconds: 200));
        if (shouldPop) {
          // If the pop is allowed, explicitly pop the route.
          // Using navigatorKey.currentContext ensures we have a valid context for pop
          // even if the widget's direct context becomes invalid during an async call.
          if (NavigatorService.navigatorKey.currentContext != null &&
              NavigatorService.navigatorKey.currentContext!.mounted) {
            // Navigator.of(
            //   NavigatorService.navigatorKey.currentContext!,
            // ).pop(true);
            NavigatorService.pop(result: true);
          }
        }
      },
      child: widget.child,
    );
  }
}

class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    NavigatorService.popCount.add(1);
    debugPrint('PUSHED: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    NavigatorService.popCount.add(-1);
    debugPrint('POPPED: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    debugPrint(
      'REPLACED: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}',
    );
  }
}

// MaterialApp में जोड़ें:
final myObserver = MyNavigatorObserver();
