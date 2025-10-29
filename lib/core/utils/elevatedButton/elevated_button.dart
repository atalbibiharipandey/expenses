import 'package:expance/core/common.dart';
import 'package:expance/core/utils/elevatedButton/one_by_one_text_animation.dart';

class ElevatedButtons extends StatefulWidget {
  const ElevatedButtons({
    super.key,
    this.onPressed,
    this.child,
    this.width,
    this.button,
    this.text,
    this.borderRadius,
    this.height,
    this.isOutlined,
    this.noWaitingAnimation,
    this.bgColor,
  });
  final Future? Function()? onPressed;
  final Widget? child;
  final double? width;
  final double? height;
  final String? text;
  final BorderRadius? borderRadius;
  final Widget? button;
  final bool? noWaitingAnimation;
  final bool? isOutlined;
  final Color? bgColor;

  @override
  State<ElevatedButtons> createState() => _ElevatedButtonsState();
}

class _ElevatedButtonsState extends State<ElevatedButtons> {
  bool status = false;
  Future<void> handleExternalFunction() async {
    try {
      // Function ko call karein aur check karein ki Future hai ya nahi

      if (widget.onPressed != null && status == false) {
        // print("Function start hone par status true karein");
        if (widget.noWaitingAnimation != true) {
          status = true;
          setState(() {});
        }
        // print("Status:- $status");
        // print("Agar Future hai, to wait karein");
        await widget.onPressed!();
        //print(t);
        // print("Function complete hone par status false karein");
        if (mounted && widget.noWaitingAnimation != true) {
          status = false;
          setState(() {});
        }
      }
    } catch (e) {
      // print("Error handling yahan karein agar zarurat ho");
      print("Error: $e");
      // Function complete hone par status false karein
      showSnackBar(e.toString(), error: true);
      if (mounted && widget.noWaitingAnimation != true) {
        status = false;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("${widget.text} Button Screen Refreshed======== Status:- $status");
    if (widget.button == null && widget.onPressed == null) {
      return const Text("onPressed Required.");
    }
    return SizedBox(
      width: widget.width ?? double.maxFinite,
      height: widget.height ?? k45,
      child:
          widget.button ??
          (widget.isOutlined == true
              ? OutlinedButton(
                  onPressed: handleExternalFunction,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: widget.bgColor ?? cPrimery,
                      width: 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: widget.bgColor ?? cPrimery,
                        width: 0.1,
                      ),
                      borderRadius: widget.borderRadius ?? borderRadius08,
                    ),
                  ),
                  child: TextAnimation(
                    text: widget.text ?? "No Data",
                    style: textSemiBoldw600.fntColor(cPrimeryText),
                    status: status,
                    child: widget.child,
                  ),
                )
              : ElevatedButton(
                  onPressed: handleExternalFunction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: widget.borderRadius ?? borderRadius08,
                    ),
                  ),
                  child: TextAnimation(
                    text: widget.text ?? "No Data",
                    style: textSemiBoldw600.fntColor(cwhiteText),
                    status: status,
                    child: widget.child,
                  ),
                )),
    );
  }
}
