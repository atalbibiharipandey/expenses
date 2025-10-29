import 'package:expance/core/common.dart';
import 'package:expance/core/utils/error_details.dart';
import 'package:expance/core/utils/progress_dialog_utils.dart';

typedef AtalMessage = String;

GlobalKey<ScaffoldMessengerState> globalMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
GlobalKey<ScaffoldMessengerState> globalMessengerKey2 =
    GlobalKey<ScaffoldMessengerState>();

showSnackBar(
  AtalMessage message, {

  Color? color,
  bool? toast,
  bool? success,
  bool? error,
}) {
  MyDialogUtils.hideProgressDialog();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final state =
        globalMessengerKey2.currentState ?? globalMessengerKey.currentState;
    if (state != null) {
      state.hideCurrentSnackBar();
      state.showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.all(k15),
            decoration: BoxDecoration(
              color:
                  color ??
                  (success == true
                      ? Colors.green
                      : error == true
                      ? Colors.red
                      : Colors.blue),
              borderRadius: borderRadius10,
            ),
            child: Row(
              spacing: k10,
              children: [
                Icon(
                  success == true
                      ? Icons.check_circle_outline_sharp
                      : success == true
                      ? Icons.error_outline_outlined
                      : Icons.info_outline,
                  color: cwhite,
                ),
                Expanded(
                  child: Text(message, style: textBoldw700.fntColor(cwhite)),
                ),
                InkWell(
                  onTap: () {
                    globalMessengerKey.currentState?.hideCurrentSnackBar();
                  },
                  child: Icon(Icons.close, color: cwhite),
                ),
              ],
            ),
          ),
          // : Container(
          //   color: cPrimery.withAlpha(50),
          //   child: BackdropFilter(
          //     filter: ui.ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          //     child: Row(
          //       spacing: k10,
          //       children: [
          //         Icon(
          //           Icons.info_outline,
          //           color: color ?? Colors.teal.shade200,
          //         ),
          //         Expanded(
          //           child: Text(
          //             message(globalMessengerKey.currentState!.context),
          //             style: textBoldw700.fntColor(color ?? cPrimery),
          //           ),
          //         ),
          //         InkWell(
          //           onTap: () {
          //             globalMessengerKey.currentState
          //                 ?.hideCurrentSnackBar();
          //           },
          //           child: Icon(Icons.close, color: cred),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius10),
          margin: margin8all,
          padding: margin8all,
          behavior: SnackBarBehavior.floating,
          // showCloseIcon: toast == true ? false : true,
          closeIconColor: cPrimery,
          elevation: 0,
        ),

        snackBarAnimationStyle: AnimationStyle(
          curve: Curves.bounceInOut,
          duration: Duration(milliseconds: 200),
        ),
      );
    }
  });
}

showSnackBarError(AtalMessage message) {
  MyDialogUtils.hideProgressDialog();
  final state =
      globalMessengerKey2.currentState ?? globalMessengerKey.currentState;
  if (state != null) {
    state.hideCurrentSnackBar();
    state.showSnackBar(
      SnackBar(
        content: Text(message, style: textBoldw700.fntColor(cred)),
        backgroundColor: Colors.red.shade50,
        //shape: const StadiumBorder(),
        margin: margin8all,
        padding: margin8all,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

showSnackBarErrorWithAction(
  String message,
  int statusCode,
  String response,
  String request,
) {
  MyDialogUtils.hideProgressDialog();
  final state =
      globalMessengerKey2.currentState ?? globalMessengerKey.currentState;
  if (state != null) {
    state.clearSnackBars();
    state.showSnackBar(
      SnackBar(
        content: Text(message, style: textBoldw700.fntColor(cred)),
        action: SnackBarAction(
          label: "Show",
          onPressed: () {
            NavigatorService.push(
              ErrorDetails(
                message: response,
                statusCode: statusCode,
                url: request,
              ),
            );
          },
        ),
        backgroundColor: Colors.red.shade50,
        //shape: const StadiumBorder(),
        margin: margin8all,
        padding: margin8all,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
