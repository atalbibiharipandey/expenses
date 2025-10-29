import 'dart:math';

import 'package:expance/core/common.dart';

bool get dark => false;

MaterialColor get cPrimery => Colors.blue;
MaterialColor get cBodyText => HexColor("#112D5B").toMaterialColor();
Color get cPrimeryWithDark => dark ? Colors.white : cPrimery;
Color get cPrimerShade50 =>
    dark ? Colors.blueGrey.shade300.withOpacity(0.3) : cPrimery.shade50;
Color get cPrimerShade100 => cPrimery.shade100;
Color get cPrimerShade200 => cPrimery.shade200;
Color get cPrimerShade300 => cPrimery.shade300;
Color get cTeal900 => Colors.teal.shade900;
Color get cCyan900 => Colors.cyan.shade900;
Color get cTeal50 => Colors.teal.shade50;
Color get cCyan50 => Colors.cyan.shade50;
Color get cwhite => dark ? Colors.black : Colors.white;
Color get cred => Colors.redAccent;
MaterialColor get cGreen => Colors.green;
Color get cgrey => dark ? Colors.blueGrey.shade100 : Colors.grey;
Color get cgrey900 => dark ? Colors.white : Colors.grey.shade900;
Color get cgrey300 =>
    dark ? Colors.blueGrey.shade300.withOpacity(0.3) : Colors.grey.shade300;
Color get cgrey400 =>
    dark ? Colors.blueGrey.shade300.withOpacity(0.3) : Colors.grey.shade400;
Color get cgrey100 =>
    dark ? Colors.blueGrey.shade300.withOpacity(0.3) : Colors.grey.shade100;
Color get cgrey50 =>
    dark ? Colors.blueGrey.shade300.withOpacity(0.3) : Colors.grey.shade50;
Color get cgrey600 => Colors.grey.shade600;
Color get cgrey700 => Colors.grey.shade700;
Color get cgrey800 => Colors.grey.shade800;
Color get cBlueGrey100 => Colors.blueGrey.shade100;
Color get cBlueGrey50 => Colors.blueGrey.shade50;
Color get cBlueGrey500 => Colors.blue.shade500;
Color get cblack => dark ? Colors.white : Colors.black;
Color get ctransparent => Colors.transparent;
Color get cHeader => const Color(0xFFBBC4C1);

Color get cPrimeryText => cPrimery;
Color get cPrimeryTextDark => dark ? Colors.white : cPrimery;
Color get cwhiteText => Colors.white;
Color get cBlackText => Colors.black;
Color get cGreyText => Colors.grey;
Color get cGoldenText => const Color(0xffF8DA97);
Color get cGoldenColor => const Color(0xffFDECC6);
Color get cBlueText => dark ? Colors.white : const Color(0xff012A4A);
Color get cBlueText1 => dark ? Colors.white : const Color(0xff0E446D);
Color get scaffoldBackgroundColor => cwhite;
Color get cBtn => HexColor("#6666ff");

LinearGradient get linearGradientGreen => const LinearGradient(
  begin: Alignment(-0.96, 0.28),
  end: Alignment(0.96, -0.28),
  colors: [Color(0xFF01B763), Color(0xFF34E794)],
);
const shadowGreen = BoxShadow(
  color: Color(0x3F01B763),
  blurRadius: 24,
  offset: Offset(4, 8),
  spreadRadius: 0,
);

TextStyle get textPrimery => TextStyle(color: cPrimeryText);
TextStyle get textPrimeryBold =>
    TextStyle(fontWeight: FontWeight.bold, color: cPrimeryText);
TextStyle get textPrimeryBoldDark =>
    TextStyle(fontWeight: FontWeight.bold, color: cPrimeryTextDark);
TextStyle get textBlack => TextStyle(color: cblack);
TextStyle get textBlackBold =>
    TextStyle(color: cblack, fontWeight: FontWeight.bold);
TextStyle get textWhite => TextStyle(color: cwhite);
TextStyle get textWhiteBold =>
    TextStyle(color: cwhite, fontWeight: FontWeight.bold);
TextStyle get textGrey => TextStyle(color: cgrey);
TextStyle get textGreyBold =>
    TextStyle(color: cgrey, fontWeight: FontWeight.bold);
TextStyle get textGrey900 => TextStyle(color: cgrey900);
TextStyle get textGrey900Bold =>
    TextStyle(color: cgrey900, fontWeight: FontWeight.bold);
TextStyle get textTeal => TextStyle(color: cTeal900);
TextStyle get textTealBold =>
    TextStyle(color: cTeal900, fontWeight: FontWeight.bold);
TextStyle get textCyan => TextStyle(color: cCyan900);
TextStyle get textCyanBold =>
    TextStyle(color: cCyan900, fontWeight: FontWeight.bold);
TextStyle textStyle(Color? color) {
  return TextStyle(color: color);
}

TextStyle get textFS16 => TextStyle(
  color: cgrey900,
  fontWeight: FontWeight.w600,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);

TextStyle get textLitew300 => TextStyle(
  fontWeight: FontWeight.w300,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);

TextStyle get textNormal =>
    TextStyle(fontSize: fs16, height: fh16, letterSpacing: ls02);
TextStyle get textMediumw500 => TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);

TextStyle get textBoldw700 => TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);
TextStyle get textSemiBoldw600 => TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);

TextStyle get textExtraBoldw800 => TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);
TextStyle get textExtriemBoldw900 => TextStyle(
  fontWeight: FontWeight.w900,
  fontSize: fs16,
  height: fh16,
  letterSpacing: ls02,
);

BoxShadow get boxShadow => BoxShadow(color: cgrey100, blurRadius: 5);

BoxDecoration get boxDecorartion => BoxDecoration(
  color: cwhite,
  borderRadius: borderRadius10,
  boxShadow: [boxShadow],
);

Decoration boxDecoration1(Color? color) {
  return BoxDecoration(color: color ?? cwhite, borderRadius: borderRadius10);
}

Decoration boxDecoration2(Color? color) {
  return BoxDecoration(
    color: color ?? cgrey100,
    borderRadius: borderRadius10,
    boxShadow: [boxShadow],
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  // For Material Colors Function Conversion.........
  MaterialColor toMaterialColor() {
    Map<int, Color> colorSwatch = {
      50: _getTintShade(0.1),
      100: _getTintShade(0.2),
      200: _getTintShade(0.3),
      300: _getTintShade(0.4),
      400: _getTintShade(0.5),
      500: Color(value), // primary color
      600: _getTintShade(-0.1),
      700: _getTintShade(-0.2),
      800: _getTintShade(-0.3),
      900: _getTintShade(-0.4),
    };
    return MaterialColor(value, colorSwatch);
  }

  Color _getTintShade(double factor) {
    int r = value >> 16 & 0xFF;
    int g = value >> 8 & 0xFF;
    int b = value & 0xFF;

    r = (r + ((factor < 0 ? r : (255 - r)) * factor)).round();
    g = (g + ((factor < 0 ? g : (255 - g)) * factor)).round();
    b = (b + ((factor < 0 ? b : (255 - b)) * factor)).round();

    return Color.fromRGBO(r, g, b, 1);
  }
}

List<MaterialColor> randomColor = [
  Colors.deepOrange,
  Colors.teal,
  Colors.indigo,
  Colors.cyan,
  // Colors.lime,
  Colors.pink,
  // Colors.amber,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.deepPurple,
];
final _colorLength = randomColor.length;
int colorState = 0;
MaterialColor getRandomColor({int? index}) {
  //return Colors.indigo;
  if (index != null) {
    return randomColor[(index % _colorLength)];
  } else {
    final ci = noRepeatIntRandomNumber(colorState, _colorLength);
    colorState = ci;
    return randomColor[ci];
  }
}

int noRepeatIntRandomNumber(int state, int randomNumberLength) {
  int ci = Random().nextInt(randomNumberLength);
  if (state != ci) {
    return ci;
  } else {
    return noRepeatIntRandomNumber(state, randomNumberLength);
  }
}
