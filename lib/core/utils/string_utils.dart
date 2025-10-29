import 'package:flutter/material.dart';

extension ToCapitalizeFirstLetter on String {
  String toCapitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + (length >= 2 ? substring(1) : '');
  }
}

class StringUtils {
  static String? nextUrl(String? url) {
    if (url != null && url.contains("page")) {
      //?page=1&limit=10
      final url1 = url.split("?");
      final list = url1.last.split("&");
      int pag = 1;
      for (int i = 0; i < list.length; i++) {
        var e = list[i];
        if (e.contains("page")) {
          final tmp = e.split("=");
          pag = int.parse(tmp.last);
          list.removeAt(i);
          break;
        }
      }

      int page = pag + 1;
      final res =
          "${url1.first}?${list.isNotEmpty ? "${list.join("&")}&" : ""}page=$page";
      // print(res);
      return res;
    } else {
      return null;
    }
  }

  static String? addTwoString(String? first, String? second) {
    if (first == null && second == null) {
      return null;
    } else if (first != null && second != null) {
      return "${first.trim()} ${second.trim()}";
    } else {
      if (first == null && second != null) {
        return second.toCapitalizeFirstLetter();
      } else {
        return first!.toCapitalizeFirstLetter();
      }
    }
  }

  static String showPrice(String? price, {String? symbol}) {
    if (price != null) {
      List<String> price1;
      List<String> price2;
      bool decimal = false;
      if (price.contains(",")) {
        return price;
      }
      if (price.contains(".")) {
        price1 = price.split(".");
        price2 = price1.first.split("");
        decimal = true;
      } else {
        price1 = price.split("");
        price2 = price1;
      }
      if (price2.length > 3) {
        int l = price2.length;
        List<String> tmp = [];
        bool s = l.isOdd;
        for (var i = 0; i < l; i++) {
          final d = price2[i];
          if (((i + (s ? 1 : 0)) % 2 == 0) && i <= (l - 3)) {
            tmp.add(d);
            tmp.add(",");
          } else {
            tmp.add(d);
          }
        }
        if (decimal) {
          tmp.add(".");
          tmp.add(price1.last);
          return "${symbol ?? '₹'} ${tmp.join("")}";
        } else {
          return "${symbol ?? '₹'} ${tmp.join("")}";
        }
      } else {
        return "${symbol ?? '₹'} $price";
      }
    } else {
      return "price not found.";
    }
  }

  static ({String? state, String? country, int? pin}) addPinCode(
    String address,
  ) {
    final statePin = address.split(",");
    print(statePin);
    int l = statePin.length;
    final pin = int.tryParse(statePin.last);
    // statePin.remove(pin?.toString());
    String? country = statePin[l - 2];
    //statePin.remove(country);
    String? state = statePin[l - 3];

    return (state: state, country: country, pin: pin);
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  int calculateTextLines({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      maxLines: null, // allow unlimited lines
    );
    tp.layout(maxWidth: maxWidth);

    // Line height = height of a single line
    // final lineHeight = tp.preferredLineHeight;

    // Number of lines = total height / line height
    // return (tp.size.height / lineHeight).ceil();
    return tp.size.height.ceil();
  }
}
