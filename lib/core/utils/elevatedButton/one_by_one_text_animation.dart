import 'package:expance/core/common.dart';

typedef callChildFunction = Function(bool status);

class OneByOneTextAnimation extends StatefulWidget {
  const OneByOneTextAnimation(
    this.text, {
    super.key,
    this.textStyle,
    this.textScaleFactor,
    this.textAlign,
    this.overflow,
    this.animationTimeMilliSecond,
    this.withoutAnimationText,
  });
  final String text;
  final String? withoutAnimationText;
  final TextStyle? textStyle;
  final double? textScaleFactor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? animationTimeMilliSecond;

  @override
  State<OneByOneTextAnimation> createState() => _OneByOneTextAnimationState();
}

class _OneByOneTextAnimationState extends State<OneByOneTextAnimation> {
  ValueNotifier<String> data = ValueNotifier("");
  Widget? withoutAnimationText;
  loopFunction() async {
    // print("Called....");
    List da = widget.text.split("");
    int length = da.length;
    if (da.isNotEmpty) {
      for (var i = 0; i < length + 1; i++) {
        await Future.delayed(
          Duration(milliseconds: widget.animationTimeMilliSecond ?? 250),
        );
        if (i == length) {
          i = 0;
          if (mounted) {
            data.value = da[i];
          }
        } else {
          if (mounted) {
            data.value += da[i];
            // print(data.value);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if ((widget.withoutAnimationText ?? '').isNotEmpty) {
      withoutAnimationText = Text(
        widget.withoutAnimationText ?? '',
        style: widget.textStyle,
        textAlign: widget.textAlign,
        overflow: widget.overflow,
        textScaler: TextScaler.linear(widget.textScaleFactor ?? 1),
      );
    }
    loopFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        withoutAnimationText ?? noWidget,
        AnimatedBuilder(
          animation: data,
          builder: (context, ch) {
            return Text(
              data.value,
              style: widget.textStyle,
              textAlign: widget.textAlign,
              overflow: widget.overflow,
              textScaler: TextScaler.linear(widget.textScaleFactor ?? 1),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }
}

class TextAnimation extends StatefulWidget {
  const TextAnimation({
    super.key,
    this.animationTimeMilliSecond,
    this.style,
    required this.text,
    required this.status,
    this.overflow,
    this.textAlign,
    this.child,
    this.textScaleFactor,
  });
  final String text;
  final TextStyle? style;
  final bool status;
  final int? animationTimeMilliSecond;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Widget? child;
  final double? textScaleFactor;

  @override
  State<TextAnimation> createState() => _TextAnimationState();
}

class _TextAnimationState extends State<TextAnimation> {
  ValueNotifier<String> data = ValueNotifier("");
  Widget? withoutAnimationText;

  loopFunction() async {
    // print("Called....");
    List da = [".", ".", "."];
    int length = da.length;
    if (da.isNotEmpty) {
      for (var i = 0; i < length + 1; i++) {
        await Future.delayed(
          Duration(milliseconds: widget.animationTimeMilliSecond ?? 300),
        );
        if (i == length) {
          i = 0;
          if (mounted) {
            data.value = da[i];
          }
        } else {
          if (mounted) {
            data.value += da[i];
            // print(data.value);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    withoutAnimationText = Text('Please Wait', style: widget.style);

    loopFunction();
  }

  @override
  void dispose() {
    data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.status == false
        ? widget.child ??
              Text(
                widget.text,
                style: widget.style,
                overflow: widget.overflow,
                textScaler: TextScaler.linear(widget.textScaleFactor ?? 1),
                textAlign: widget.textAlign,
              )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              withoutAnimationText ?? noWidget,
              SizedBox(
                width: (widget.style?.fontSize ?? k15),
                child: AnimatedBuilder(
                  animation: data,
                  builder: (context, ch) {
                    return Text(
                      data.value,
                      style: widget.style,
                      textScaler: TextScaler.linear(
                        widget.textScaleFactor ?? 1,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class PleaseWaitBuilder extends StatefulWidget {
  const PleaseWaitBuilder({super.key, required this.builder});
  final Widget Function(
    BuildContext context,
    callChildFunction pleaseWait,
    bool status,
  )
  builder;

  @override
  State<PleaseWaitBuilder> createState() => _PleaseWaitBuilderState();
}

class _PleaseWaitBuilderState extends State<PleaseWaitBuilder> {
  bool showPleaseWaitStatus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, showPleaseWait, showPleaseWaitStatus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  showPleaseWait(bool status) {
    showPleaseWaitStatus = status;
    setState(() {});
  }
}
