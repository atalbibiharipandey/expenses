import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class WrapFlex extends MultiChildRenderObjectWidget {
  final double spacing;
  final double runSpacing;

  const WrapFlex({
    super.key,
    required super.children,
    this.spacing = 0,
    this.runSpacing = 0,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFlexWrap(spacing: spacing, runSpacing: runSpacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderFlexWrap renderObject,
  ) {
    renderObject
      ..spacing = spacing
      ..runSpacing = runSpacing;
  }
}

class FlexWrapParentData extends ContainerBoxParentData<RenderBox> {}

class RenderFlexWrap extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, FlexWrapParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, FlexWrapParentData> {
  RenderFlexWrap({double spacing = 0, double runSpacing = 0})
    : _spacing = spacing,
      _runSpacing = runSpacing;

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing != value) {
      _spacing = value;
      markNeedsLayout();
    }
  }

  double _runSpacing;
  double get runSpacing => _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing != value) {
      _runSpacing = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! FlexWrapParentData) {
      child.parentData = FlexWrapParentData();
    }
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final double maxWidth = constraints.maxWidth;

    double y = 0;
    double rowHeight = 0;

    final rows = <_Row>[];
    var currentRow = <RenderBox>[];
    double usedWidth = 0;

    RenderBox? child = firstChild;

    // group children into rows
    while (child != null) {
      child.layout(constraints.loosen(), parentUsesSize: true);
      final childParentData = child.parentData as FlexWrapParentData;

      final childWidth = child.size.width;
      final childHeight = child.size.height;

      final double nextWidth =
          (currentRow.isEmpty ? 0 : usedWidth + spacing) + childWidth;

      if (nextWidth > maxWidth && currentRow.isNotEmpty) {
        rows.add(_Row(currentRow, rowHeight));
        y += rowHeight + runSpacing;

        currentRow = [];
        usedWidth = 0;
        rowHeight = 0;
      }

      currentRow.add(child);
      usedWidth =
          (currentRow.length == 1 ? 0 : usedWidth + spacing) + childWidth;
      rowHeight = rowHeight < childHeight ? childHeight : rowHeight;

      child = childParentData.nextSibling;
    }

    if (currentRow.isNotEmpty) {
      rows.add(_Row(currentRow, rowHeight));
    }

    // 2nd pass: layout again rows with expanded widths
    y = 0;
    for (var row in rows) {
      final totalChildWidth = row.children.fold<double>(
        0,
        (sum, c) => sum + c.size.width,
      );
      final totalSpacing = (row.children.length - 1) * spacing;
      final extra = maxWidth - (totalChildWidth + totalSpacing);

      double dx = 0;

      if (extra > 0 && row.children.isNotEmpty) {
        final extraPerChild = extra / row.children.length;

        for (var child in row.children) {
          final childParentData = child.parentData as FlexWrapParentData;
          final double newWidth = child.size.width + extraPerChild;

          child.layout(
            BoxConstraints(
              minWidth: newWidth,
              maxWidth: newWidth,
              minHeight: child.size.height,
              maxHeight: child.size.height,
            ),
            parentUsesSize: true,
          );

          childParentData.offset = Offset(dx, y);
          dx += child.size.width + spacing;
        }
      } else {
        for (var child in row.children) {
          final childParentData = child.parentData as FlexWrapParentData;
          childParentData.offset = Offset(dx, y);
          dx += child.size.width + spacing;
        }
      }

      y += row.height + runSpacing;
    }

    size = constraints.constrain(Size(maxWidth, y - runSpacing));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

class _Row {
  final List<RenderBox> children;
  final double height;

  _Row(this.children, this.height);
}

// class WrapFlex extends MultiChildRenderObjectWidget {
//   final double spacing;
//   final double runSpacing;
//   final WrapAlignment alignment;
//   final WrapAlignment runAlignment;
//   final Axis direction;

//   /// Example:---------------------------------------------
//   ///```dart
//   /// FlexWrap(
//   ///   spacing: 8,
//   ///   runSpacing: 8,
//   ///   alignment: WrapAlignment.spaceEvenly,
//   ///   runAlignment: WrapAlignment.center,
//   ///   direction: Axis.horizontal,
//   ///   children: List.generate(10, (i) => Container(
//   ///     width: 100 + (i * 10),
//   ///     height: 40,
//   ///     color: Colors.primaries[i % Colors.primaries.length],
//   ///   )),
//   /// )
//   /// ```
//   const WrapFlex({
//     super.key,
//     required super.children,
//     this.spacing = 0,
//     this.runSpacing = 0,
//     this.alignment = WrapAlignment.start,
//     this.runAlignment = WrapAlignment.start,
//     this.direction = Axis.horizontal,
//   });

//   @override
//   RenderObject createRenderObject(BuildContext context) {
//     return RenderFlexWrap(
//       spacing: spacing,
//       runSpacing: runSpacing,
//       alignment: alignment,
//       runAlignment: runAlignment,
//       direction: direction,
//     );
//   }

//   @override
//   void updateRenderObject(
//     BuildContext context,
//     covariant RenderFlexWrap renderObject,
//   ) {
//     renderObject
//       ..spacing = spacing
//       ..runSpacing = runSpacing
//       ..alignment = alignment
//       ..runAlignment = runAlignment
//       ..direction = direction;
//   }
// }

// class FlexWrapParentData extends ContainerBoxParentData<RenderBox> {}

// class RenderFlexWrap extends RenderBox
//     with
//         ContainerRenderObjectMixin<RenderBox, FlexWrapParentData>,
//         RenderBoxContainerDefaultsMixin<RenderBox, FlexWrapParentData> {
//   RenderFlexWrap({
//     double spacing = 0,
//     double runSpacing = 0,
//     WrapAlignment alignment = WrapAlignment.start,
//     WrapAlignment runAlignment = WrapAlignment.start,
//     Axis direction = Axis.horizontal,
//   }) : _spacing = spacing,
//        _runSpacing = runSpacing,
//        _alignment = alignment,
//        _runAlignment = runAlignment,
//        _direction = direction;

//   double _spacing;
//   double get spacing => _spacing;
//   set spacing(double value) {
//     if (_spacing != value) {
//       _spacing = value;
//       markNeedsLayout();
//     }
//   }

//   double _runSpacing;
//   double get runSpacing => _runSpacing;
//   set runSpacing(double value) {
//     if (_runSpacing != value) {
//       _runSpacing = value;
//       markNeedsLayout();
//     }
//   }

//   WrapAlignment _alignment;
//   WrapAlignment get alignment => _alignment;
//   set alignment(WrapAlignment value) {
//     if (_alignment != value) {
//       _alignment = value;
//       markNeedsLayout();
//     }
//   }

//   WrapAlignment _runAlignment;
//   WrapAlignment get runAlignment => _runAlignment;
//   set runAlignment(WrapAlignment value) {
//     if (_runAlignment != value) {
//       _runAlignment = value;
//       markNeedsLayout();
//     }
//   }

//   Axis _direction;
//   Axis get direction => _direction;
//   set direction(Axis value) {
//     if (_direction != value) {
//       _direction = value;
//       markNeedsLayout();
//     }
//   }

//   @override
//   void setupParentData(RenderBox child) {
//     if (child.parentData is! FlexWrapParentData) {
//       child.parentData = FlexWrapParentData();
//     }
//   }

//   @override
//   void performLayout() {
//     final BoxConstraints constraints = this.constraints;
//     final double maxMain = direction == Axis.horizontal
//         ? constraints.maxWidth
//         : constraints.maxHeight;

//     double mainPos = 0, crossExtent = 0;
//     final runs = <_Run>[];
//     var childrenInRun = <RenderBox>[];

//     RenderBox? child = firstChild;

//     // Step 1: measure children and group into runs
//     while (child != null) {
//       child.layout(constraints.loosen(), parentUsesSize: true);
//       final childParentData = child.parentData as FlexWrapParentData;
//       final childSize = child.size;

//       final double childMain = direction == Axis.horizontal
//           ? childSize.width
//           : childSize.height;
//       final double childCross = direction == Axis.horizontal
//           ? childSize.height
//           : childSize.width;

//       final double nextMain =
//           (childrenInRun.isEmpty ? 0 : mainPos + spacing) + childMain;

//       if (nextMain > maxMain && childrenInRun.isNotEmpty) {
//         runs.add(_Run(childrenInRun, crossExtent));
//         mainPos = 0;
//         crossExtent = 0;
//         childrenInRun = [];
//       }

//       childrenInRun.add(child);
//       mainPos = (childrenInRun.length == 1 ? 0 : mainPos + spacing) + childMain;
//       crossExtent = crossExtent < childCross ? childCross : crossExtent;

//       child = childParentData.nextSibling;
//     }
//     if (childrenInRun.isNotEmpty) {
//       runs.add(_Run(childrenInRun, crossExtent));
//     }

//     // Step 2: calculate total size
//     final totalMain = maxMain.isFinite
//         ? maxMain
//         : runs.fold<double>(0, (sum, r) {
//             final runMain = r.children.fold<double>(
//               0,
//               (s, c) =>
//                   s +
//                   (direction == Axis.horizontal ? c.size.width : c.size.height),
//             );
//             return sum + runMain + (r.children.length - 1) * spacing;
//           });

//     final totalCross =
//         runs.fold<double>(0, (sum, r) => sum + r.crossExtent) +
//         (runs.length - 1) * runSpacing;

//     size = direction == Axis.horizontal
//         ? constraints.constrain(Size(totalMain, totalCross))
//         : constraints.constrain(Size(totalCross, totalMain));

//     // Step 3: distribute runs along cross axis
//     double crossStart = _computeRunOffset(
//       runAlignment,
//       direction == Axis.horizontal ? size.height : size.width,
//       totalCross,
//       runs.length,
//       runSpacing,
//     );

//     // Step 4: place children
//     for (var run in runs) {
//       final runMainExtent = run.children.fold<double>(
//         0,
//         (s, c) =>
//             s + (direction == Axis.horizontal ? c.size.width : c.size.height),
//       );
//       final totalSpacing = spacing * (run.children.length - 1);
//       final freeSpace = maxMain - runMainExtent - totalSpacing;

//       final double leadingSpace;
//       final double betweenSpace;
//       switch (alignment) {
//         case WrapAlignment.start:
//           leadingSpace = 0;
//           betweenSpace = spacing;
//           break;
//         case WrapAlignment.end:
//           leadingSpace = freeSpace;
//           betweenSpace = spacing;
//           break;
//         case WrapAlignment.center:
//           leadingSpace = freeSpace / 2;
//           betweenSpace = spacing;
//           break;
//         case WrapAlignment.spaceBetween:
//           leadingSpace = 0;
//           betweenSpace = run.children.length > 1
//               ? spacing + freeSpace / (run.children.length - 1)
//               : 0;
//           break;
//         case WrapAlignment.spaceAround:
//           betweenSpace = run.children.isNotEmpty
//               ? spacing + freeSpace / run.children.length
//               : 0;
//           leadingSpace = betweenSpace / 2;
//           break;
//         case WrapAlignment.spaceEvenly:
//           betweenSpace = run.children.isNotEmpty
//               ? spacing + freeSpace / (run.children.length + 1)
//               : 0;
//           leadingSpace = betweenSpace;
//           break;
//       }

//       double mainPos = leadingSpace;
//       for (var child in run.children) {
//         final childParentData = child.parentData as FlexWrapParentData;
//         final dx = direction == Axis.horizontal ? mainPos : crossStart;
//         final dy = direction == Axis.horizontal ? crossStart : mainPos;
//         childParentData.offset = Offset(dx, dy);
//         mainPos +=
//             (direction == Axis.horizontal
//                 ? child.size.width
//                 : child.size.height) +
//             betweenSpace;
//       }

//       crossStart += run.crossExtent + runSpacing;
//     }
//   }

//   double _computeRunOffset(
//     WrapAlignment alignment,
//     double containerExtent,
//     double totalContentExtent,
//     int runCount,
//     double runSpacing,
//   ) {
//     final freeSpace = containerExtent - totalContentExtent;
//     switch (alignment) {
//       case WrapAlignment.start:
//         return 0;
//       case WrapAlignment.end:
//         return freeSpace;
//       case WrapAlignment.center:
//         return freeSpace / 2;
//       case WrapAlignment.spaceBetween:
//         return 0;
//       case WrapAlignment.spaceAround:
//         return freeSpace / (runCount * 2);
//       case WrapAlignment.spaceEvenly:
//         return freeSpace / (runCount + 1);
//     }
//   }

//   @override
//   void paint(PaintingContext context, Offset offset) {
//     defaultPaint(context, offset);
//   }

//   @override
//   bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
//     return defaultHitTestChildren(result, position: position);
//   }
// }

// class _Run {
//   final List<RenderBox> children;
//   final double crossExtent;
//   _Run(this.children, this.crossExtent);
// }
