import 'package:expance/core/common.dart';

class Containers {
  Widget cardColorBgIcon({
    required Widget child,
    double? width,
    double? height,
    IconData? bgIcon,
    double? bgIconSize,
    bool? noBgIcon,
    BorderRadius? borderRadius,
  }) {
    final color = getRandomColor();
    return Container(
      clipBehavior: Clip.hardEdge,
      width: width == 0 ? null : width ?? 200.fem,
      height: height == 0 ? null : height ?? 150.fem,
      // constraints: BoxConstraints(minHeight: 130.fem, maxHeight: 150.fem),
      padding: margin108,
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: borderRadius ?? borderRadius08,
        boxShadow: [boxShadow],
      ),
      child: Stack(
        children: [
          if (noBgIcon != true)
            Center(
              child: Icon(
                bgIcon ?? Icons.assignment_outlined,
                color: color.withAlpha(25),
                size: bgIconSize ?? 120.fem,
              ),
            ),
          child,
        ],
      ),
    );
  }

  Widget cardColor({
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    MaterialColor? bgColor,
  }) {
    final color = bgColor ?? getRandomColor();
    return Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      padding: padding ?? margin83,
      decoration: BoxDecoration(
        color: dark ? cgrey100 : color.shade50,
        borderRadius: borderRadius ?? borderRadius08,
        boxShadow: [boxShadow],
      ),
      child: child,
    );
  }
}

class ContainerShadow extends StatelessWidget {
  const ContainerShadow({
    super.key,
    this.margin,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.alignment,
    required this.child,
  });
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final AlignmentGeometry? alignment;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? margin108,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? cwhite,
        borderRadius: borderRadius ?? borderRadius15,
        boxShadow: [
          // BoxShadow(
          //   color: cgrey300,
          //   offset: Offset(1, 1),
          //   blurRadius: 2,
          //   spreadRadius: 1,
          // ),
          BoxShadow(
            color: cgrey300,
            offset: Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class ContainerGradient extends StatelessWidget {
  const ContainerGradient({
    super.key,
    this.margin,
    this.padding,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.alignment,
    required this.child,
    this.hideGradient,
  });
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final AlignmentGeometry? alignment;
  final Widget child;
  final bool? hideGradient;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? (dark ? cgrey300 : cwhite),
        borderRadius: borderRadius ?? borderRadius08,
        boxShadow: [
          BoxShadow(
            color: cgrey300,
            offset: Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
        gradient: hideGradient ?? false
            ? null
            : LinearGradient(
                colors: [
                  HexColor("#6666ff"),
                  HexColor("#bf83fc"),
                ], // Indigo → Blue
                transform: GradientRotation(0.5),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      child: child,
    );
  }
}
