import 'package:expance/core/common.dart';

class TextWidget {
  Widget textWithIcon(
    String text, {
    Widget? icon,
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: k08,
      children: [
        if (icon != null) icon,
        Flexible(
          child: Text(
            text,
            style: style ?? textNormal,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
      ],
    );
  }

  Widget seeAll(String? lable, VoidCallback? onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lable ?? "No Text.", style: textSemiBoldw600),
        TextButton(
          onPressed: onTap,
          child: Text("See All >", style: textMediumw500),
        ),
      ],
    );
  }
}
