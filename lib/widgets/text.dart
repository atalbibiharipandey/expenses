import 'package:expance/core/common.dart';

class MyTextWidget {
  Widget textContainterBg(
    String? text, {
    Color? color,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? Function(TextStyle? style)? style,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? cPrimery).withAlpha(80),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text ?? "No Text",
        style: style != null
            ? (style(
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: (color ?? cPrimery),
                ),
              ))
            : TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: (color ?? cPrimery),
              ),
      ),
    );
  }

  Widget bigHeading(
    String? title,
    String? subtitle, {
    IconData? icon,
    double? iSizse,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: iSizse ?? k40, color: cblack),
        if (icon != null) wsBox04,
        Text(title ?? "No Title", style: textBoldw700.fntSize(30)),
        hsBox03,
        Text(
          subtitle ?? "No SubTitle",
          style: textMediumw500.fntColor(HexColor("#6b7280")),
        ),
      ],
    );
  }

  Widget heading(
    String? title,
    String? subtitle, {
    IconData? icon,
    double? iSizse,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: iSizse ?? k25, color: cblack),
            if (icon != null) wsBox04,
            Flexible(
              child: Text(
                title ?? "No Title",
                style: textSemiBoldw600.fntSize(24),
              ),
            ),
          ],
        ),
        hsBox03,
        Text(
          subtitle ?? "No SubTitle",
          style: textMediumw500.fntColor(HexColor("#6b7280")).fntSize(14),
        ),
      ],
    );
  }

  Widget textColumn(
    String? title,
    String? subtitle, {
    IconData? icon,
    double? tSize,
    double? bSize,
    TextStyle? tStyle,
    TextStyle? bStyle,
    bool? swap,
  }) {
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: tSize ?? k18, color: cblack),
        if (icon != null) wsBox04,
        Flexible(
          child: Text(
            title ?? "No Title",
            style: tStyle ?? textSemiBoldw600.fntSize(tSize ?? 16),
          ),
        ),
      ],
    );
    int l = (subtitle ?? '').length;
    int limit = 150;
    bool showFull = false;
    Function(void Function())? sts;
    return IgnorePointer(
      ignoring: l < limit,
      child: InkWell(
        onTap: () {
          showFull = !showFull;
          sts?.call(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (swap != true) row,
            if (swap != true) hsBox03,
            StatefulBuilder(
              builder: (context, setState) {
                sts = setState;

                return Text(
                  l < limit
                      ? (subtitle ?? "No SubTitle")
                      : showFull == true
                      ? subtitle!
                      : subtitle!.substring(0, limit),
                  style:
                      bStyle ??
                      textMediumw500
                          .fntColor(HexColor("#6b7280"))
                          .fntSize(bSize ?? 14),
                );
              },
            ),
            if (swap == true) hsBox03,
            if (swap == true) row,
          ],
        ),
      ),
    );
  }

  Widget iconText(
    String? text, {
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    TextStyle? style,
    double? space,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: iconSize ?? k18),
        SizedBox(width: space ?? k08),
        Text(
          text ?? "No Data",
          style: style ?? textMediumw500.fntSize(14).copyWith(color: iconColor),
        ),
      ],
    );
  }

  Widget textWithProgressBar(String? title, double? value, {Color? indicator}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: k15,
              height: k15,
              decoration: BoxDecoration(
                color: indicator ?? Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            wsBox08,
            Text(title ?? "No Data", style: textBoldw700),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 130.fem,
              child: LinearProgressIndicator(
                value: value,
                color: cBtn,
                borderRadius: borderRadius50,
                minHeight: k08,
              ),
            ),
            wsBox10,
            Text(
              "${((value ?? 0) * 100).toStringAsFixed(0)}%",
              style: textMediumw500.fntColor(cgrey),
            ),
          ],
        ),
      ],
    );
  }
}
