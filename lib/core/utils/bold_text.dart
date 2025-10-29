import 'package:flutter/material.dart';

/// Wrap with * which String You want to Bold in Text.
/// Like 'Hello *Atal Bihari Pandey*, welcome!'
class TextBold extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? boldStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const TextBold(
    this.text, {
    super.key,
    this.style,
    this.boldStyle,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
    this.textScaleFactor,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      // textScaleFactor: textScaleFactor ?? MediaQuery.of(context).textScaleFactor,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: textHeightBehavior,
      text: TextSpan(children: _parseText(text, baseStyle)),
    );
  }

  List<TextSpan> _parseText(String text, TextStyle baseStyle) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*(.*?)\*');
    final matches = regex.allMatches(text);
    int lastIndex = 0;

    for (final match in matches) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: baseStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: boldStyle ?? baseStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      );

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex), style: baseStyle));
    }

    return spans;
  }
}


// TextBold(
//   text: 'Hello *Atal Bihari Pandey*, welcome!',
//   style: TextStyle(fontSize: 16, color: Colors.black),
//   boldStyle: TextStyle(
//     fontSize: 16,
//     color: Colors.blue,
//     fontWeight: FontWeight.w900,
//     letterSpacing: 0.5,
//   ),
// )