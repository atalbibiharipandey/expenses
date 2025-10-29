import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension MyResponsive on num {
  double get fem => getHorizontalSize(toDouble());
  double get fs => getFontSize(toDouble());
  double get fh => getFontHeight(toDouble());
  double get ls => letterSpacing(toDouble());
}

// This is where the magic happens.
// This functions are responsible to make UI responsive across all the mobile devices.

// Size size = WidgetsBinding.instance!.window.physicalSize /
//     WidgetsBinding.instance!.window.devicePixelRatio;
late Size size;

// Caution! If you think these are static values and are used to build a static UI,  you mustn’t.
// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
const num figmaDesignWidth = 392.72;
const double maxExpandScreen = 650;
// const num fIGMA_DESIGN_HEIGHT = 812;
// const num fIGMA_DESIGN_STATUS_BAR = 44;
late double fem1;
late double ffem1;

Size getSize(BuildContext context) {
  size = MediaQuery.of(context).size;

  deviceSize();

  fem1 = limitedSize(size);
  ffem1 = fem1 * 0.97;
  return size;
}

double limitedSize(Size size) {
  // yaha size ko limite kar raha he agar size 800 se adhik he to vah 800 he lega.
  final size0 = getSize1(size);
  // print(size0);
  if (size0 < maxExpandScreen) {
    return size0 / figmaDesignWidth;
  } else {
    return maxExpandScreen / figmaDesignWidth;
  }

  //return size0 / figmaDesignWidth;
}

///This method is used to set smallest px in image height and width
double getSize1(Size size) {
  var height = size.height;
  var width = size.width;
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to get device viewport width.
// get width {
//   return size1.width;
// }

///This method is used to get device viewport height.
// get height {
//   num statusBar = MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
//       .viewPadding
//       .top;
//   num bottomBar = MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
//       .viewPadding
//       .bottom;
//   num screenHeight = size1.height - statusBar - bottomBar;
//   return screenHeight;
// }

///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
double getHorizontalSize(double px) {
  if (web) {
    return px;
  }
  return (px * fem1);
}

///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
double getVerticalSize(double px) {
  return (px * fem1);
}

///This method is used to set text font size according to Viewport
double getFontSize(double px) {
  // return getSize1(px);
  if (web) {
    return px;
  }
  return (px * ffem1);
}

double getFontHeight(double px) {
  // return getSize1(px);
  return (px * (ffem1 / fem1));
}

double letterSpacing(double px) {
  return px * fem1;
}

///This method is used to set padding responsively
EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

///This method is used to set margin responsively
EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  return getMarginOrPadding(
    all: all,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );
}

EdgeInsetsGeometry getMarginSymentric({double? vertical, double? horizontal}) {
  return getMarginOrPadding(
    left: horizontal,
    right: horizontal,
    top: vertical,
    bottom: vertical,
  );
}

///This method is used to get padding or margin responsively
EdgeInsetsGeometry getMarginOrPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  // print("Left:- $left, Right:- $right, Top:- $top, Bottom:- $bottom");
  return EdgeInsets.only(
    left: getHorizontalSize(left ?? 0),
    top: getVerticalSize(top ?? 0),
    right: getHorizontalSize(right ?? 0),
    bottom: getVerticalSize(bottom ?? 0),
  );
}

// margin
EdgeInsetsGeometry get margin20all => getMarginOrPadding(all: 20);
EdgeInsetsGeometry get margin2010 =>
    getMarginSymentric(horizontal: k20, vertical: k10);
EdgeInsetsGeometry get margin208 =>
    getMarginSymentric(horizontal: k20, vertical: 8);
EdgeInsetsGeometry get margin205 =>
    getMarginSymentric(horizontal: k20, vertical: 5);
EdgeInsetsGeometry get margin203 =>
    getMarginSymentric(horizontal: k20, vertical: 3);
EdgeInsetsGeometry get margin20zero =>
    getMarginSymentric(horizontal: 20, vertical: 0);
EdgeInsetsGeometry get margin20rtb10 =>
    EdgeInsets.only(left: web ? k10 : k20, right: k20, top: k20, bottom: k20);
EdgeInsetsGeometry get margin10all => getMarginOrPadding(all: 10);
EdgeInsetsGeometry get margin108 =>
    getMarginSymentric(horizontal: 10, vertical: 8);
EdgeInsetsGeometry get margin105 =>
    getMarginSymentric(horizontal: 10, vertical: 5);
EdgeInsetsGeometry get margin103 =>
    getMarginSymentric(horizontal: 10, vertical: 3);
EdgeInsetsGeometry get margin10zero =>
    getMarginSymentric(horizontal: 10, vertical: 0);
EdgeInsetsGeometry get margin8all => getMarginOrPadding(all: 8);
EdgeInsetsGeometry get margin85 =>
    getMarginSymentric(horizontal: 8, vertical: 5);
EdgeInsetsGeometry get margin83 =>
    getMarginSymentric(horizontal: 8, vertical: 3);
EdgeInsetsGeometry get margin8zero =>
    getMarginSymentric(horizontal: 8, vertical: 0);
EdgeInsetsGeometry get margin5all => getMarginOrPadding(all: 5);
EdgeInsetsGeometry get margin53 =>
    getMarginSymentric(horizontal: 5, vertical: 3);
EdgeInsetsGeometry get margin5zero =>
    getMarginSymentric(horizontal: 5, vertical: 0);
EdgeInsetsGeometry get margin3all => getMarginOrPadding(all: 3);
EdgeInsetsGeometry get margin32 =>
    getMarginSymentric(horizontal: 3, vertical: 2);
EdgeInsetsGeometry get margin31 =>
    getMarginSymentric(horizontal: 3, vertical: 1);
EdgeInsetsGeometry get margin3zero =>
    getMarginSymentric(horizontal: 3, vertical: 0);
EdgeInsetsGeometry get margin2all => getMarginOrPadding(all: 2);
EdgeInsetsGeometry get margin21 =>
    getMarginSymentric(horizontal: 2, vertical: 1);
EdgeInsetsGeometry get margin2zero =>
    getMarginSymentric(horizontal: 2, vertical: 0);
EdgeInsetsGeometry get margin1all => getMarginOrPadding(all: 1);
EdgeInsetsGeometry get marginZero => EdgeInsets.zero;

// border Radius circuler
BorderRadius get borderRadius50 => BorderRadius.circular(getVerticalSize(50));
BorderRadius get borderRadius45 => BorderRadius.circular(getVerticalSize(45));
BorderRadius get borderRadius40 => BorderRadius.circular(getVerticalSize(40));
BorderRadius get borderRadius35 => BorderRadius.circular(getVerticalSize(35));
BorderRadius get borderRadius30 => BorderRadius.circular(getVerticalSize(30));
BorderRadius get borderRadius26 => BorderRadius.circular(getVerticalSize(26));
BorderRadius get borderRadius25 => BorderRadius.circular(getVerticalSize(25));
BorderRadius get borderRadius24 => BorderRadius.circular(getVerticalSize(24));
BorderRadius get borderRadius22 => BorderRadius.circular(getVerticalSize(22));
BorderRadius get borderRadius20 => BorderRadius.circular(getVerticalSize(20));
BorderRadius get borderRadius18 => BorderRadius.circular(getVerticalSize(18));
BorderRadius get borderRadius15 => BorderRadius.circular(getVerticalSize(15));
BorderRadius get borderRadius12 => BorderRadius.circular(getVerticalSize(12));
BorderRadius get borderRadius10 => BorderRadius.circular(getVerticalSize(10));
BorderRadius get borderRadius08 => BorderRadius.circular(getVerticalSize(8));
BorderRadius get borderRadius05 => BorderRadius.circular(getVerticalSize(5));
BorderRadius get borderRadius03 => BorderRadius.circular(getVerticalSize(3));
BorderRadius get borderRadius04 => BorderRadius.circular(getVerticalSize(4));

// sized box height
SizedBox get hsBox50 => SizedBox(height: getVerticalSize(50));
SizedBox get hsBox49 => SizedBox(height: getVerticalSize(49));
SizedBox get hsBox48 => SizedBox(height: getVerticalSize(48));
SizedBox get hsBox47 => SizedBox(height: getVerticalSize(47));
SizedBox get hsBox46 => SizedBox(height: getVerticalSize(46));
SizedBox get hsBox45 => SizedBox(height: getVerticalSize(45));
SizedBox get hsBox44 => SizedBox(height: getVerticalSize(44));
SizedBox get hsBox43 => SizedBox(height: getVerticalSize(43));
SizedBox get hsBox42 => SizedBox(height: getVerticalSize(42));
SizedBox get hsBox41 => SizedBox(height: getVerticalSize(41));
SizedBox get hsBox40 => SizedBox(height: getVerticalSize(40));
SizedBox get hsBox39 => SizedBox(height: getVerticalSize(39));
SizedBox get hsBox38 => SizedBox(height: getVerticalSize(38));
SizedBox get hsBox37 => SizedBox(height: getVerticalSize(37));
SizedBox get hsBox36 => SizedBox(height: getVerticalSize(36));
SizedBox get hsBox35 => SizedBox(height: getVerticalSize(35));
SizedBox get hsBox34 => SizedBox(height: getVerticalSize(34));
SizedBox get hsBox33 => SizedBox(height: getVerticalSize(33));
SizedBox get hsBox32 => SizedBox(height: getVerticalSize(32));
SizedBox get hsBox31 => SizedBox(height: getVerticalSize(31));
SizedBox get hsBox30 => SizedBox(height: getVerticalSize(30));
SizedBox get hsBox29 => SizedBox(height: getVerticalSize(29));
SizedBox get hsBox28 => SizedBox(height: getVerticalSize(28));
SizedBox get hsBox27 => SizedBox(height: getVerticalSize(27));
SizedBox get hsBox26 => SizedBox(height: getVerticalSize(26));
SizedBox get hsBox25 => SizedBox(height: getVerticalSize(25));
SizedBox get hsBox24 => SizedBox(height: getVerticalSize(24));
SizedBox get hsBox23 => SizedBox(height: getVerticalSize(23));
SizedBox get hsBox22 => SizedBox(height: getVerticalSize(22));
SizedBox get hsBox21 => SizedBox(height: getVerticalSize(21));
SizedBox get hsBox20 => SizedBox(height: getVerticalSize(20));
SizedBox get hsBox19 => SizedBox(height: getVerticalSize(19));
SizedBox get hsBox18 => SizedBox(height: getVerticalSize(18));
SizedBox get hsBox17 => SizedBox(height: getVerticalSize(17));
SizedBox get hsBox16 => SizedBox(height: getVerticalSize(16));
SizedBox get hsBox15 => SizedBox(height: getVerticalSize(15));
SizedBox get hsBox14 => SizedBox(height: getVerticalSize(14));
SizedBox get hsBox13 => SizedBox(height: getVerticalSize(13));
SizedBox get hsBox12 => SizedBox(height: getVerticalSize(12));
SizedBox get hsBox11 => SizedBox(height: getVerticalSize(11));
SizedBox get hsBox10 => SizedBox(height: getVerticalSize(10));
SizedBox get hsBox09 => SizedBox(height: getVerticalSize(9));
SizedBox get hsBox08 => SizedBox(height: getVerticalSize(8));
SizedBox get hsBox07 => SizedBox(height: getVerticalSize(7));
SizedBox get hsBox06 => SizedBox(height: getVerticalSize(6));
SizedBox get hsBox05 => SizedBox(height: getVerticalSize(5));
SizedBox get hsBox04 => SizedBox(height: getVerticalSize(4));
SizedBox get hsBox03 => SizedBox(height: getVerticalSize(3));
SizedBox get hsBox02 => SizedBox(height: getVerticalSize(2));
SizedBox get hsBox01 => SizedBox(height: getVerticalSize(1));
// sized box width.
SizedBox get wsBox50 => SizedBox(width: getVerticalSize(50));
SizedBox get wsBox49 => SizedBox(width: getVerticalSize(49));
SizedBox get wsBox48 => SizedBox(width: getVerticalSize(48));
SizedBox get wsBox47 => SizedBox(width: getVerticalSize(47));
SizedBox get wsBox46 => SizedBox(width: getVerticalSize(46));
SizedBox get wsBox45 => SizedBox(width: getVerticalSize(45));
SizedBox get wsBox44 => SizedBox(width: getVerticalSize(44));
SizedBox get wsBox43 => SizedBox(width: getVerticalSize(43));
SizedBox get wsBox42 => SizedBox(width: getVerticalSize(42));
SizedBox get wsBox41 => SizedBox(width: getVerticalSize(41));
SizedBox get wsBox40 => SizedBox(width: getVerticalSize(40));
SizedBox get wsBox39 => SizedBox(width: getVerticalSize(39));
SizedBox get wsBox38 => SizedBox(width: getVerticalSize(38));
SizedBox get wsBox37 => SizedBox(width: getVerticalSize(37));
SizedBox get wsBox36 => SizedBox(width: getVerticalSize(36));
SizedBox get wsBox35 => SizedBox(width: getVerticalSize(35));
SizedBox get wsBox34 => SizedBox(width: getVerticalSize(34));
SizedBox get wsBox33 => SizedBox(width: getVerticalSize(33));
SizedBox get wsBox32 => SizedBox(width: getVerticalSize(32));
SizedBox get wsBox31 => SizedBox(width: getVerticalSize(31));
SizedBox get wsBox30 => SizedBox(width: getVerticalSize(30));
SizedBox get wsBox29 => SizedBox(width: getVerticalSize(29));
SizedBox get wsBox28 => SizedBox(width: getVerticalSize(28));
SizedBox get wsBox27 => SizedBox(width: getVerticalSize(27));
SizedBox get wsBox26 => SizedBox(width: getVerticalSize(26));
SizedBox get wsBox25 => SizedBox(width: getVerticalSize(25));
SizedBox get wsBox24 => SizedBox(width: getVerticalSize(24));
SizedBox get wsBox23 => SizedBox(width: getVerticalSize(23));
SizedBox get wsBox22 => SizedBox(width: getVerticalSize(22));
SizedBox get wsBox21 => SizedBox(width: getVerticalSize(21));
SizedBox get wsBox20 => SizedBox(width: getVerticalSize(20));
SizedBox get wsBox19 => SizedBox(width: getVerticalSize(19));
SizedBox get wsBox18 => SizedBox(width: getVerticalSize(18));
SizedBox get wsBox17 => SizedBox(width: getVerticalSize(17));
SizedBox get wsBox16 => SizedBox(width: getVerticalSize(16));
SizedBox get wsBox15 => SizedBox(width: getVerticalSize(15));
SizedBox get wsBox14 => SizedBox(width: getVerticalSize(14));
SizedBox get wsBox13 => SizedBox(width: getVerticalSize(13));
SizedBox get wsBox12 => SizedBox(width: getVerticalSize(12));
SizedBox get wsBox11 => SizedBox(width: getVerticalSize(11));
SizedBox get wsBox10 => SizedBox(width: getVerticalSize(10));
SizedBox get wsBox09 => SizedBox(width: getVerticalSize(9));
SizedBox get wsBox08 => SizedBox(width: getVerticalSize(8));
SizedBox get wsBox07 => SizedBox(width: getVerticalSize(7));
SizedBox get wsBox06 => SizedBox(width: getVerticalSize(6));
SizedBox get wsBox05 => SizedBox(width: getVerticalSize(5));
SizedBox get wsBox04 => SizedBox(width: getVerticalSize(4));
SizedBox get wsBox03 => SizedBox(width: getVerticalSize(3));
SizedBox get wsBox02 => SizedBox(width: getVerticalSize(2));
SizedBox get wsBox01 => SizedBox(width: getVerticalSize(1));
const noWidget = SizedBox.shrink();

// spaced
double get k01 => 1.fem;
double get k02 => 2.fem;
double get k03 => 3.fem;
double get k04 => 4.fem;
double get k05 => 5.fem;
double get k06 => 6.fem;
double get k07 => 7.fem;
double get k08 => 8.fem;
double get k09 => 9.fem;
double get k10 => 10.fem;
double get k11 => 11.fem;
double get k12 => 12.fem;
double get k13 => 13.fem;
double get k14 => 14.fem;
double get k15 => 15.fem;
double get k16 => 16.fem;
double get k17 => 17.fem;
double get k18 => 18.fem;
double get k19 => 19.fem;
double get k20 => 20.fem;
double get k21 => 21.fem;
double get k22 => 22.fem;
double get k23 => 23.fem;
double get k24 => 24.fem;
double get k25 => 25.fem;
double get k26 => 26.fem;
double get k27 => 27.fem;
double get k28 => 28.fem;
double get k29 => 29.fem;
double get k30 => 30.fem;
double get k31 => 31.fem;
double get k32 => 32.fem;
double get k33 => 33.fem;
double get k34 => 34.fem;
double get k35 => 35.fem;
double get k36 => 36.fem;
double get k37 => 37.fem;
double get k38 => 38.fem;
double get k39 => 39.fem;
double get k40 => 40.fem;
double get k41 => 41.fem;
double get k42 => 42.fem;
double get k43 => 43.fem;
double get k44 => 44.fem;
double get k45 => 45.fem;
double get k46 => 46.fem;
double get k47 => 47.fem;
double get k48 => 48.fem;
double get k49 => 49.fem;
double get k50 => 50.fem;
double get k51 => 51.fem;
double get k52 => 52.fem;
double get k53 => 53.fem;
double get k54 => 54.fem;
double get k55 => 55.fem;
double get k56 => 56.fem;
double get k57 => 57.fem;
double get k58 => 58.fem;
double get k59 => 59.fem;
double get k60 => 60.fem;
double get k61 => 61.fem;
double get k62 => 62.fem;
double get k63 => 63.fem;
double get k64 => 64.fem;
double get k65 => 65.fem;
double get k66 => 66.fem;
double get k67 => 67.fem;
double get k68 => 68.fem;
double get k69 => 69.fem;
double get k70 => 70.fem;
double get k71 => 71.fem;
double get k72 => 72.fem;
double get k73 => 73.fem;
double get k74 => 74.fem;
double get k75 => 75.fem;
double get k76 => 76.fem;
double get k77 => 77.fem;
double get k78 => 78.fem;
double get k79 => 79.fem;
double get k80 => 80.fem;
double get k81 => 81.fem;
double get k82 => 82.fem;
double get k83 => 83.fem;
double get k84 => 84.fem;
double get k85 => 85.fem;
double get k86 => 86.fem;
double get k87 => 87.fem;
double get k88 => 88.fem;
double get k89 => 89.fem;
double get k90 => 90.fem;
double get k91 => 91.fem;
double get k92 => 92.fem;
double get k93 => 93.fem;
double get k94 => 94.fem;
double get k95 => 95.fem;
double get k96 => 96.fem;
double get k97 => 97.fem;
double get k98 => 98.fem;
double get k99 => 99.fem;
double get k100 => 100.fem;

// font sized
extension AtalFontSizeJi on TextStyle {
  TextStyle fntSize(double px) {
    return copyWith(fontSize: getFontSize(px));
  }
}

double get fs01 => 1.fs;
double get fs02 => 2.fs;
double get fs03 => 3.fs;
double get fs04 => 4.fs;
double get fs05 => 5.fs;
double get fs06 => 6.fs;
double get fs07 => 7.fs;
double get fs08 => 8.fs;
double get fs09 => 9.fs;
double get fs10 => 10.fs;
double get fs11 => 11.fs;
double get fs12 => 12.fs;
double get fs13 => 13.fs;
double get fs14 => 14.fs;
double get fs15 => 15.fs;
double get fs16 => 16.fs;
double get fs17 => 17.fs;
double get fs18 => 18.fs;
double get fs19 => 19.fs;
double get fs20 => 20.fs;
double get fs21 => 21.fs;
double get fs22 => 22.fs;
double get fs23 => 23.fs;
double get fs24 => 24.fs;
double get fs25 => 25.fs;
double get fs26 => 26.fs;
double get fs27 => 27.fs;
double get fs28 => 28.fs;
double get fs29 => 29.fs;
double get fs30 => 30.fs;
double get fs31 => 31.fs;
double get fs32 => 32.fs;
double get fs33 => 33.fs;
double get fs34 => 34.fs;
double get fs35 => 35.fs;
double get fs36 => 36.fs;
double get fs37 => 37.fs;
double get fs38 => 38.fs;
double get fs39 => 39.fs;
double get fs40 => 40.fs;
double get fs41 => 41.fs;
double get fs42 => 42.fs;
double get fs43 => 43.fs;
double get fs44 => 44.fs;
double get fs45 => 45.fs;
double get fs46 => 46.fs;
double get fs47 => 47.fs;
double get fs48 => 48.fs;
double get fs49 => 49.fs;
double get fs50 => 50.fs;

// font Height
extension AtalFontHeight on TextStyle {
  TextStyle fntHeight(double px) {
    return copyWith(height: getFontHeight(px));
  }
}

double get fh01 => 0.1.fh;
double get fh02 => 0.2.fh;
double get fh03 => 0.3.fh;
double get fh04 => 0.4.fh;
double get fh05 => 0.5.fh;
double get fh06 => 0.6.fh;
double get fh07 => 0.7.fh;
double get fh08 => 0.8.fh;
double get fh09 => 0.9.fh;
double get fh10 => 1.fh;
double get fh11 => 1.1.fh;
double get fh12 => 1.2.fh;
double get fh13 => 1.3.fh;
double get fh14 => 1.4.fh;
double get fh15 => 1.5.fh;
double get fh16 => 1.6.fh;
double get fh17 => 1.7.fh;
double get fh18 => 1.8.fh;
double get fh19 => 1.9.fh;
double get fh20 => 2.0.fh;
double get fh21 => 2.1.fh;
double get fh22 => 2.2.fh;
double get fh23 => 2.3.fh;
double get fh24 => 2.4.fh;
double get fh25 => 2.5.fh;
double get fh26 => 2.6.fh;
double get fh27 => 2.7.fh;
double get fh28 => 2.8.fh;
double get fh29 => 2.9.fh;
double get fh30 => 3.0.fh;
double get fh31 => 3.1.fh;
double get fh32 => 3.2.fh;
double get fh33 => 3.3.fh;
double get fh34 => 3.4.fh;
double get fh35 => 3.5.fh;
double get fh36 => 3.6.fh;
double get fh37 => 3.7.fh;
double get fh38 => 3.8.fh;
double get fh39 => 3.9.fh;
double get fh40 => 4.0.fh;
double get fh41 => 4.1.fh;
double get fh42 => 4.2.fh;
double get fh43 => 4.3.fh;
double get fh44 => 4.4.fh;
double get fh45 => 4.5.fh;
double get fh46 => 4.6.fh;
double get fh47 => 4.7.fh;
double get fh48 => 4.8.fh;
double get fh49 => 4.9.fh;
double get fh50 => 5.0.fh;

// font Latter spacing
extension AtalFontLatterSpacing on TextStyle {
  TextStyle fntLatterSpacing(double px) {
    return copyWith(letterSpacing: letterSpacing(px));
  }
}

double get ls01 => 0.1.ls;
double get ls02 => 0.2.ls;
double get ls03 => 0.3.ls;
double get ls04 => 0.4.ls;
double get ls05 => 0.5.ls;
double get ls06 => 0.6.ls;
double get ls07 => 0.7.ls;
double get ls08 => 0.8.ls;
double get ls09 => 0.9.ls;
double get ls10 => 1.0.ls;
double get ls11 => 1.1.ls;
double get ls12 => 1.2.ls;
double get ls13 => 1.3.ls;
double get ls14 => 1.4.ls;
double get ls15 => 1.5.ls;
double get ls16 => 1.6.ls;
double get ls17 => 1.7.ls;
double get ls18 => 1.8.ls;
double get ls19 => 1.9.ls;
double get ls20 => 2.0.ls;
double get ls21 => 2.1.ls;
double get ls22 => 2.2.ls;
double get ls23 => 2.3.ls;
double get ls24 => 2.4.ls;
double get ls25 => 2.5.ls;
double get ls26 => 2.6.ls;
double get ls27 => 2.7.ls;
double get ls28 => 2.8.ls;
double get ls29 => 2.9.ls;
double get ls30 => 3.0.ls;
double get ls31 => 3.1.ls;
double get ls32 => 3.2.ls;
double get ls33 => 3.3.ls;
double get ls34 => 3.4.ls;
double get ls35 => 3.5.ls;
double get ls36 => 3.6.ls;
double get ls37 => 3.7.ls;
double get ls38 => 3.8.ls;
double get ls39 => 3.9.ls;
double get ls40 => 4.0.ls;
double get ls41 => 4.1.ls;
double get ls42 => 4.2.ls;
double get ls43 => 4.3.ls;
double get ls44 => 4.4.ls;
double get ls45 => 4.5.ls;
double get ls46 => 4.6.ls;
double get ls47 => 4.7.ls;
double get ls48 => 4.8.ls;
double get ls49 => 4.9.ls;
double get ls50 => 5.0.ls;

extension AtalFontBold on TextStyle {
  TextStyle get fontBold {
    return copyWith(fontWeight: FontWeight.bold);
  }
}

extension AtalFontBoldJi on TextStyle {
  TextStyle fntBold(FontWeight bold) {
    return copyWith(fontWeight: bold);
  }
}

extension AtalFontColor on TextStyle {
  TextStyle fntColor(Color color) {
    return copyWith(color: color);
  }
}

enum DeviceType { web, android, ios, macOs, windows, linux }

DeviceType deviceSize() {
  double? width = size.width;
  if (width >= 800) {
    web = true;
    // debugPrint("Screen Size($width) Desktop...........................");
    return DeviceType.web;
  } else {
    web = false;
    debugPrint(
      "Screen Size($width) Unknown......Web:- $web.....................",
    );
    return DeviceType.android;
  }
}

late bool web;

DeviceType? deviceType;
DeviceType devicePlatformType() {
  if (kIsWeb) {
    print('Running on the web!');
    deviceType = DeviceType.web;
    return DeviceType.web;
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        deviceType = DeviceType.android;
        return DeviceType.android;
      case TargetPlatform.iOS:
        deviceType = DeviceType.ios;
        return DeviceType.ios;
      case TargetPlatform.macOS:
        deviceType = DeviceType.macOs;
        return DeviceType.macOs;
      case TargetPlatform.windows:
        deviceType = DeviceType.windows;
        return DeviceType.windows;
      case TargetPlatform.linux:
        deviceType = DeviceType.linux;
        return DeviceType.linux;
      default:
        print("Platform Not Found..........");
        deviceType = DeviceType.android;
        return DeviceType.android;
    }
  }
}

// import 'package:flutter/material.dart';

// // This is where the magic happens.
// // This functions are responsible to make UI responsive across all the mobile devices.

// Size size = WidgetsBinding.instance.window.physicalSize /
//     WidgetsBinding.instance.window.devicePixelRatio;

// // Caution! If you think these are static values and are used to build a static UI,  you mustn’t.
// // These are the Viewport values of your Figma Design.
// // These are used in the code as a reference to create your UI Responsively.
// const num FIGMA_DESIGN_WIDTH = 430;
// const num FIGMA_DESIGN_HEIGHT = 932;
// const num FIGMA_DESIGN_STATUS_BAR = 44;

// ///This method is used to get device viewport width.
// get width {
//   return size.width;
// }

// ///This method is used to get device viewport height.
// get height {
//   num statusBar =
//       MediaQueryData.fromView(WidgetsBinding.instance.).viewPadding.top;
//   num bottomBar = MediaQueryData.fromView(WidgetsBinding.instance.window)
//       .viewPadding
//       .bottom;
//   num screenHeight = size.height - statusBar - bottomBar;
//   return screenHeight;
// }

// ///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
// double getHorizontalSize(double px) {
//   return ((px * width) / FIGMA_DESIGN_WIDTH);
// }

// ///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
// double getVerticalSize(double px) {
//   return ((px * height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR));
// }

// ///This method is used to set smallest px in image height and width
// double getSize(double px) {
//   var height = getVerticalSize(px);
//   var width = getHorizontalSize(px);
//   if (height < width) {
//     return height.toInt().toDouble();
//   } else {
//     return width.toInt().toDouble();
//   }
// }

// ///This method is used to set text font size according to Viewport
// double getFontSize(double px) {
//   return getSize(px);
// }

// ///This method is used to set padding responsively
// EdgeInsets getPadding({
//   double? all,
//   double? left,
//   double? top,
//   double? right,
//   double? bottom,
// }) {
//   return getMarginOrPadding(
//     all: all,
//     left: left,
//     top: top,
//     right: right,
//     bottom: bottom,
//   );
// }

// ///This method is used to set margin responsively
// EdgeInsets getMargin({
//   double? all,
//   double? left,
//   double? top,
//   double? right,
//   double? bottom,
// }) {
//   return getMarginOrPadding(
//     all: all,
//     left: left,
//     top: top,
//     right: right,
//     bottom: bottom,
//   );
// }

// ///This method is used to get padding or margin responsively
// EdgeInsets getMarginOrPadding({
//   double? all,
//   double? left,
//   double? top,
//   double? right,
//   double? bottom,
// }) {
//   if (all != null) {
//     left = all;
//     top = all;
//     right = all;
//     bottom = all;
//   }
//   return EdgeInsets.only(
//     left: getHorizontalSize(
//       left ?? 0,
//     ),
//     top: getVerticalSize(
//       top ?? 0,
//     ),
//     right: getHorizontalSize(
//       right ?? 0,
//     ),
//     bottom: getVerticalSize(
//       bottom ?? 0,
//     ),
//   );
// }
