import 'package:expance/core/common.dart';
import 'package:shimmer/shimmer.dart';

Shimmer simmerContainer(Widget child) {
  return Shimmer.fromColors(
    baseColor: cgrey300,
    highlightColor: cgrey100,
    child: child,
  );
}

class SimmerEffect {
  static Widget container({
    double? width,
    double? height,
    Widget? child,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: borderRadius),
      child: simmerContainer(Container(color: cwhite, child: child)),
    );
  }

  static Widget text(
    String? text, {
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: const EdgeInsets.all(1),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: borderRadius),
      child: simmerContainer(
        Container(
          color: cwhite,
          child: Text(
            text ?? "atal Bihari Pa",
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
