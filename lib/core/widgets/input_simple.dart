import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:expance/core/common.dart';
import 'package:expance/core/widgets/scroll_glow_manager.dart';

extension My1TextEditingController on String? {
  TextEditingController tc() {
    if (this == null) {
      return TextEditingController();
    } else {
      TextEditingController textEditingController = TextEditingController(
        text: this ?? '',
      );
      return textEditingController;
    }
  }
}

enum InputValidator { gst, pan, email, webUrl }

enum BorderType { bottom, outer }

class InputValue<T> {
  final String text;
  final T? value;

  InputValue(this.text, {this.value});
}

extension InputValueExtension on List? {
  List<InputValue> toInputValueList() =>
      (this ?? []).map((e) => InputValue(e.toString().trim())).toList();
}

/// if you want to show SnackBar and also Scroll to Targeted Input Box
/// Please Use:-  SmartFormRegistry.showSnackBarFlag = true;
class InputSimple extends StatefulWidget {
  final String? lable;
  final bool? hideLabel;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final TextEditingController? controller;
  final bool? disposeController;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Widget? suffixIcon;
  final Widget Function(TextEditingController tec)? suffixIconBuilder;
  final bool? readOnly;
  final bool? ignorePointer;
  final bool? border;
  final bool? notValidate;
  final VoidCallback? onTap;
  final double? height;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final InputValidator? validator;
  final bool? isTextArea;
  final bool? noSpaceLabel;
  final bool? isCollapsed;
  final AutovalidateMode? autovalidateMode;
  final BorderType? borderType;
  final TextStyle? style;
  final void Function(String)? onChanged;
  final void Function(InputValue)? onSelect;
  final bool? dropdownButton;
  final FutureOr<List<InputValue>>? dropdownData;
  final Function(bool highlight, InputValue data)? suggestionBuilder;
  final bool? suggestionRequired;
  final bool? showMultipleSelect;
  final int? multipleSelectLimit;
  final Function(List<InputValue> data)? multiSelect;
  final bool? showMultiSelectAddBtn;
  final Color? colorBorder;
  const InputSimple({
    Key? key,
    this.lable,
    required this.hintText,
    this.labelStyle,
    this.noSpaceLabel,
    this.prefixIcon,
    this.controller,
    this.disposeController,
    this.notValidate,
    this.hintStyle,
    this.suffixIcon,
    this.readOnly,
    this.onTap,
    this.border,
    this.height,
    this.isCollapsed,
    this.maxLines,
    this.keyboardType,
    this.isTextArea,
    this.maxLength,
    this.validator,
    this.autovalidateMode,
    this.borderType,
    this.prefix,
    this.onChanged,
    this.style,
    this.dropdownButton,
    this.dropdownData,
    this.suggestionBuilder,
    this.multipleSelectLimit,
    this.onSelect,
    this.suggestionRequired,
    this.suffixIconBuilder,
    this.showMultipleSelect,
    this.multiSelect,
    this.showMultiSelectAddBtn,
    this.ignorePointer,
    this.colorBorder,
    this.hideLabel,
  }) : super(key: key);

  @override
  State<InputSimple> createState() => _InputSimpleState();
}

class _InputSimpleState extends State<InputSimple> {
  Color focusColor = HexColor("#112D5B");
  Color unFocusColor = HexColor("#1D417B99");
  List<InputValue> multiValue = [];
  ValueNotifier<String?> message = ValueNotifier(null);
  double? rightPaddingOfSuggestionBuilder;
  ValueNotifier<bool> showMultiSelectManualBtn = ValueNotifier(false);
  bool showSimmer = false;
  Size? sizeN;
  InputBorder inputBorder({Color? color}) {
    return widget.border ?? false
        ? widget.borderType == BorderType.bottom
              ? const UnderlineInputBorder()
              : OutlineInputBorder(
                  borderRadius: borderRadius10,
                  borderSide: BorderSide(
                    color: color ?? focusColor,
                    width: 0.8,
                  ),
                )
        : InputBorder.none;
  }

  List<InputValue>? suggestionData;
  String? tmpValue;
  String? tmpSelectDropdownData;
  bool? focus;

  @override
  void initState() {
    super.initState();

    if (widget.colorBorder != null) {
      focusColor = widget.colorBorder!;
    }
    tmpValue = widget.controller?.text;
    if (widget.showMultipleSelect == true) {
      if (widget.controller == null || widget.controller!.text.isEmpty) {
        multiValue = [];
        widget.controller?.text = '';
      } else {
        multiValue =
            widget.controller?.text
                .split(",")
                .map((e) => e.trim())
                .toList()
                .toInputValueList() ??
            [];
        widget.controller?.text = '';
      }
    }
  }

  @override
  void dispose() {
    suggestionData = null;
    if (widget.disposeController == true && widget.controller != null) {
      widget.controller?.dispose();
    }
    message.dispose();
    showMultiSelectManualBtn.dispose;
    SmartFormRegistry.showSnackBarFlag = false;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputSimple oldWidget) {
    super.didUpdateWidget(oldWidget);
    // showSimmer = true;
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   showSimmer = false;
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    // FocusNode _focusNode = FocusNode();

    // sizeN ??= MediaQuery.of(context).size;

    Size? cSize = MediaQuery.of(context).size;
    // print(csizeN.width);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        cSize = context.size;
      }
      // print('Widget width: ${cSize?.width}');
    });
    tmpValue = widget.controller?.text;

    return LayoutBuilder(
      builder: (context, box) {
        sizeN ??= box.biggest;
        // printl(["Refresh Text Field----"]);
        return IgnorePointer(
          ignoring: widget.ignorePointer ?? false,
          child: SizedBox(
            height: widget.height,
            width: maxExpandScreen > sizeN!.width
                ? sizeN!.width
                : sizeN!.width / 2.2,
            child: showSimmer
                ? Column(
                    children: [
                      widget.lable == null || widget.hideLabel == true
                          ? const SizedBox.shrink()
                          : SimmerEffect.text("Lable Text"),
                      widget.lable == null ||
                              widget.noSpaceLabel == true ||
                              widget.hideLabel == true
                          ? const SizedBox.shrink()
                          : SizedBox(height: k08),
                      SimmerEffect.container(
                        height: widget.height ?? k45,
                        borderRadius: borderRadius10,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.lable == null || widget.hideLabel == true
                          ? const SizedBox.shrink()
                          : Text.rich(
                              TextSpan(
                                text: widget.lable,
                                style:
                                    widget.labelStyle ??
                                    TextStyle(
                                      fontWeight: FontWeight.w600,
                                      height: fh16,
                                      color: focusColor,
                                      letterSpacing: ls02,
                                      shadows: [
                                        Shadow(blurRadius: 3, color: cgrey),
                                      ],
                                      fontSize: fs15,
                                    ),
                                children: [
                                  TextSpan(
                                    text: widget.notValidate == true ? "" : "*",
                                    style:
                                        widget.hintStyle?.fntColor(cred) ??
                                        TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: cred,
                                          height: fh16,
                                          letterSpacing: ls02,
                                          fontSize: fs15,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                      widget.lable == null ||
                              widget.noSpaceLabel == true ||
                              widget.hideLabel == true
                          ? const SizedBox.shrink()
                          : SizedBox(height: k08),
                      widget.dropdownButton == true &&
                              widget.dropdownData != null
                          ? Column(
                              children: [
                                Autocomplete<InputValue>(
                                  initialValue:
                                      widget.controller != null &&
                                          widget.controller!.text.isNotEmpty
                                      ? TextEditingValue(
                                          text: widget.controller!.text,
                                        )
                                      : null,
                                  optionsMaxHeight: 200,

                                  optionsBuilder:
                                      (
                                        TextEditingValue fruitTextEditingValue,
                                      ) async {
                                        // if user is input nothing
                                        // if (fruitTextEditingValue.text.isEmpty) {
                                        //   return (suggestionData ?? <InputValue>[]);
                                        // }
                                        if (fruitTextEditingValue
                                                .text
                                                .isEmpty &&
                                            widget.showMultiSelectAddBtn ==
                                                true &&
                                            widget.showMultipleSelect == true) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((c) {
                                                showMultiSelectManualBtn.value =
                                                    false;
                                              });
                                        }

                                        // if user is input something the build
                                        // suggestion based on the user input
                                        printf([
                                          "Filter Text:- ${fruitTextEditingValue.text}",
                                        ]);
                                        suggestionData ??=
                                            await widget.dropdownData;
                                        final tmp =
                                            (suggestionData ?? <InputValue>[])
                                                .where((InputValue option) {
                                                  return option.text
                                                      .toLowerCase()
                                                      .contains(
                                                        fruitTextEditingValue
                                                            .text
                                                            .toLowerCase(),
                                                      );
                                                });
                                        if (tmp.isEmpty &&
                                            fruitTextEditingValue
                                                .text
                                                .isNotEmpty &&
                                            widget.showMultiSelectAddBtn ==
                                                true &&
                                            widget.showMultipleSelect == true) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((c) {
                                                showMultiSelectManualBtn.value =
                                                    true;
                                              });
                                        }
                                        return Future.value(tmp);
                                      },

                                  // when user click on the suggested
                                  // item this function calls
                                  onSelected: (InputValue value) {
                                    // debugPrint('You just selected $value');
                                    widget.controller?.text = value.text;
                                    if (widget.onChanged != null) {
                                      widget.onChanged!(value.text);
                                    }
                                    if (widget.onSelect != null) {
                                      widget.onSelect!(value);
                                    }
                                    if (widget.showMultipleSelect == true) {
                                      if (widget.multipleSelectLimit != null &&
                                          multiValue.length >=
                                              widget.multipleSelectLimit!) {
                                        message.value =
                                            "You Can Select only ${widget.multipleSelectLimit}.";
                                      } else {
                                        final t5 = ((multiValue)
                                            .singleWhere(
                                              (e) => e.text == value.text,
                                              orElse: () => InputValue(""),
                                            )
                                            .text);
                                        if (t5 != value.text) {
                                          multiValue.add(value);
                                          if (widget.multiSelect != null) {
                                            widget.multiSelect!(multiValue);
                                          }
                                        }
                                      }
                                    }
                                    FocusScope.of(context).unfocus();
                                  },

                                  optionsViewBuilder: (context, onSelected, options) {
                                    final l = options.length;
                                    final showHeight = l > 3;
                                    // print("ShrinkWrap:${!showHeight}");
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                          rightPaddingOfSuggestionBuilder ??=
                                              (sizeN!.width -
                                                      (cSize?.width ??
                                                          (sizeN!.width - 10)))
                                                  .roundToDouble();
                                        });
                                    printf([options.toList()]);
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              rightPaddingOfSuggestionBuilder ??
                                              (sizeN!.width -
                                                      (cSize?.width ??
                                                          (sizeN!.width - 10)))
                                                  .roundToDouble(),
                                          // bottom: k08,
                                        ),
                                        // padding: EdgeInsets.only(right: k10),
                                        child: Material(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(k10),
                                            bottomRight: Radius.circular(k10),
                                          ),
                                          color: cwhite,
                                          elevation: 4,
                                          child: Container(
                                            height: showHeight ? 205 : null,
                                            padding: EdgeInsets.only(
                                              bottom: k08,
                                            ),
                                            child: ListView.builder(
                                              shrinkWrap: !showHeight,
                                              itemCount: options.length,
                                              itemBuilder: (context, index) {
                                                final e = options.elementAt(
                                                  index,
                                                );
                                                final bool highlight =
                                                    AutocompleteHighlightedOption.of(
                                                      context,
                                                    ) ==
                                                    index;
                                                if (highlight) {
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                        (Duration timeStamp) {
                                                          Scrollable.ensureVisible(
                                                            context,
                                                            alignment: 0,
                                                          );
                                                        },
                                                        debugLabel:
                                                            'AutocompleteOptions.ensureVisible',
                                                      );
                                                }
                                                if (e.text.isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return Builder(
                                                  builder: (context) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                        top: k08,
                                                        left: k08,
                                                        right: k08,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          onSelected(e);
                                                          tmpSelectDropdownData =
                                                              e.text;
                                                        },
                                                        child:
                                                            widget.suggestionBuilder !=
                                                                null
                                                            ? widget
                                                                  .suggestionBuilder!(
                                                                highlight,
                                                                e,
                                                              )
                                                            : Container(
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      highlight
                                                                      ? Theme.of(
                                                                          context,
                                                                        ).focusColor
                                                                      : null,
                                                                  borderRadius:
                                                                      borderRadius10,
                                                                  border:
                                                                      widget.border ==
                                                                          true
                                                                      ? Border.all(
                                                                          color:
                                                                              focusColor,
                                                                          width:
                                                                              0.5,
                                                                        )
                                                                      : null,
                                                                ),
                                                                child: ListTile(
                                                                  visualDensity:
                                                                      VisualDensity
                                                                          .compact,
                                                                  leading:
                                                                      widget.prefixIcon !=
                                                                          null
                                                                      ? Icon(
                                                                          widget
                                                                              .prefixIcon,
                                                                        )
                                                                      : widget
                                                                            .prefix,
                                                                  title: Text(
                                                                    e.text,
                                                                    style:
                                                                        widget
                                                                            .hintStyle ??
                                                                        widget
                                                                            .style ??
                                                                        TextStyle(
                                                                          color:
                                                                              cgrey900,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              fh16,
                                                                          letterSpacing:
                                                                              ls02,
                                                                          fontSize:
                                                                              fs16,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  fieldViewBuilder:
                                      (
                                        context,
                                        textEditingController,
                                        focusNode,
                                        onFieldSubmitted,
                                      ) {
                                        widget.controller?.text =
                                            textEditingController.text;

                                        return FocusScope(
                                          onFocusChange: (value) {
                                            // print("Focus of This Widget:$value");
                                            // if (focus == value) {
                                            //   return;
                                            // }
                                            // focus = value;
                                            if (value) {
                                              tmpValue =
                                                  textEditingController.text;
                                              textEditingController.text = "";
                                              if (widget.readOnly != true) {
                                                textEditingController.text =
                                                    tmpValue ?? '';
                                              }
                                              // WidgetsBinding.instance
                                              //     .addPostFrameCallback((timeStamp) {
                                              //   setState(() {});
                                              // });
                                            }
                                            if (value == false) {
                                              if (widget.readOnly == true) {
                                                if (textEditingController
                                                    .text
                                                    .isEmpty) {
                                                  textEditingController.text =
                                                      tmpValue ?? '';
                                                }
                                              }
                                              if (widget.showMultipleSelect ==
                                                  true) {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((
                                                      timeStamp,
                                                    ) {
                                                      textEditingController
                                                          .clear();
                                                    });
                                              } else {
                                                acceptOnlySuggestionValue(
                                                  textEditingController,
                                                  focusNode,
                                                  suggestionData!,
                                                  tmpSelectDropdownData,
                                                );
                                              }
                                            }
                                          },
                                          child: textField(
                                            focusNode: focusNode,
                                            textEditingController:
                                                textEditingController,
                                            onFieldSubmitted: onFieldSubmitted,
                                            suffix:
                                                widget.showMultiSelectAddBtn ==
                                                        true &&
                                                    widget.showMultipleSelect ==
                                                        true
                                                ? ValueListenableBuilder(
                                                    valueListenable:
                                                        showMultiSelectManualBtn,
                                                    builder: (context, value, child) {
                                                      return value
                                                          ? TextButton(
                                                              onPressed: () {
                                                                if (widget
                                                                        .showMultipleSelect ==
                                                                    true) {
                                                                  if (widget.multipleSelectLimit !=
                                                                          null &&
                                                                      multiValue
                                                                              .length >=
                                                                          widget
                                                                              .multipleSelectLimit!) {
                                                                    message.value =
                                                                        "You Can Select only ${widget.multipleSelectLimit}.";
                                                                  } else {
                                                                    final t5 = ((multiValue)
                                                                        .singleWhere(
                                                                          (e) =>
                                                                              e.text ==
                                                                              textEditingController.text,
                                                                          orElse: () => InputValue(
                                                                            "",
                                                                          ),
                                                                        )
                                                                        .text);
                                                                    if (t5 !=
                                                                        textEditingController
                                                                            .text) {
                                                                      multiValue.add(
                                                                        InputValue(
                                                                          textEditingController
                                                                              .text,
                                                                          value:
                                                                              textEditingController.text,
                                                                        ),
                                                                      );
                                                                      if (widget
                                                                              .multiSelect !=
                                                                          null) {
                                                                        widget
                                                                            .multiSelect!(
                                                                          multiValue,
                                                                        );
                                                                      }
                                                                      textEditingController
                                                                          .clear();
                                                                      showMultiSelectManualBtn
                                                                              .value =
                                                                          false;
                                                                      setState(
                                                                        () {},
                                                                      );
                                                                      FocusScope.of(
                                                                        context,
                                                                      ).unfocus();
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                              child: Text(
                                                                "Add",
                                                              ),
                                                            )
                                                          : noWidget;
                                                    },
                                                  )
                                                : null,
                                            onTapOutside: () {
                                              acceptOnlySuggestionValue(
                                                textEditingController,
                                                focusNode,
                                                suggestionData!,
                                                tmpSelectDropdownData,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                ),
                                if (widget.showMultipleSelect == true)
                                  StatefulBuilder(
                                    builder: (context, st) {
                                      return Container(
                                        margin: EdgeInsets.only(top: k10),
                                        width: double.maxFinite,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ValueListenableBuilder(
                                              valueListenable: message,
                                              builder: (context, value, child) {
                                                if (message.value == null) {
                                                  return noWidget;
                                                }
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: k05,
                                                  ),
                                                  child: Text(
                                                    message.value ?? '',
                                                    style: textMediumw500
                                                        .fntColor(cred),
                                                  ),
                                                );
                                              },
                                            ),
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              runSpacing: k10,
                                              spacing: k10,
                                              children: multiValue
                                                  .asMap()
                                                  .map(
                                                    (i, v) => MapEntry(
                                                      i,
                                                      Container(
                                                        // constraints: BoxConstraints(
                                                        //   maxWidth: 300,
                                                        // ),
                                                        padding:
                                                            EdgeInsets.only(
                                                              left: 15,
                                                              right: 10,
                                                              bottom: 7,
                                                              top: 7,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: cBodyText,
                                                          border: Border.all(
                                                            width: 0.5,
                                                            color: cBodyText,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                500,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          spacing: 5,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                v.text,
                                                                style: textNormal
                                                                    .fntColor(
                                                                      cwhiteText,
                                                                    ),
                                                              ),
                                                            ),

                                                            InkWell(
                                                              onTap: () {
                                                                multiValue
                                                                    .removeAt(
                                                                      i,
                                                                    );
                                                                if (widget
                                                                        .multiSelect !=
                                                                    null) {
                                                                  widget
                                                                      .multiSelect!(
                                                                    multiValue,
                                                                  );
                                                                }
                                                                if (widget.multipleSelectLimit !=
                                                                        null &&
                                                                    widget.multipleSelectLimit! >=
                                                                        multiValue
                                                                            .length) {
                                                                  message.value =
                                                                      null;
                                                                }
                                                                st.call(() {});
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .close_rounded,
                                                                size: k20,
                                                                color: cred,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .values
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            )
                          : textField(),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget textField({
    TextEditingController? textEditingController,
    FocusNode? focusNode,
    void Function()? onFieldSubmitted,
    VoidCallback? onTapOutside,
    Widget? suffix,
  }) {
    if (widget.lable != null && widget.notValidate != true) {
      return SmartFormField(
        label: widget.lable!,
        noValidate: widget.notValidate,
        validator: textFieldValidating,
        borderRadius: borderRadius10,
        controller:
            textEditingController ??
            widget.controller ??
            TextEditingController(),

        child: textField1(
          focusNode: focusNode,
          textEditingController:
              textEditingController ??
              widget.controller ??
              TextEditingController(),
          onFieldSubmitted: onFieldSubmitted,
          onTapOutside: onTapOutside,
          suffix: suffix,
        ),
      );
    } else {
      return textField1(
        focusNode: focusNode,
        textEditingController:
            textEditingController ??
            widget.controller ??
            TextEditingController(),
        onFieldSubmitted: onFieldSubmitted,
        onTapOutside: onTapOutside,
        suffix: suffix,
      );
    }
  }

  TextFormField textField1({
    TextEditingController? textEditingController,
    FocusNode? focusNode,
    void Function()? onFieldSubmitted,
    VoidCallback? onTapOutside,
    Widget? suffix,
  }) {
    final cnt = textEditingController ?? widget.controller;
    return TextFormField(
      onTap: widget.onTap,
      focusNode: focusNode,
      onTapOutside: (event) {
        if (onTapOutside != null) {
          onTapOutside();
        }
      },
      scrollPadding: EdgeInsets.zero,

      readOnly: widget.readOnly ?? false,
      controller: cnt,
      maxLines: widget.maxLines,
      minLines: widget.isTextArea == true ? 2 : 1,
      keyboardType: widget.keyboardType,
      style:
          widget.style ??
          TextStyle(
            color: cgrey900,
            fontWeight: FontWeight.bold,
            height: fh16,
            letterSpacing: ls02,
            fontSize: fs16,
          ),
      validator: (s) {
        // print("Validating Called With:- $s");
        if (widget.notValidate != true && widget.lable != null) {
          // print("Validating Inside Called With:- $s");
          SmartFormRegistry.validateAndScroll();
        }
        return textFieldValidating(s);
      },
      autovalidateMode: widget.autovalidateMode,
      cursorColor: cblack,
      textAlignVertical: TextAlignVertical.center,
      maxLength: widget.maxLength,

      // focusNode: _focusNode,
      onChanged: (s) {
        if (widget.onChanged != null) {
          widget.onChanged!(s);
        }
        tmpSelectDropdownData = s;
      },
      onFieldSubmitted: (value) {
        if (onFieldSubmitted != null) {
          onFieldSubmitted();
        }
      },

      //textAlign: TextAlign.center,
      decoration: InputDecoration(
        //isDense: true,
        isCollapsed: widget.isCollapsed,
        //contentPadding: EdgeInsets.symmetric(horizontal: k16),
        border: inputBorder(),
        isDense: true,
        focusedBorder: inputBorder(color: focusColor),
        enabledBorder: inputBorder(),
        errorBorder: inputBorder(color: cred),
        prefixIcon:
            widget.prefix ??
            (widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: cBlueGrey100)
                : null),
        suffixIcon:
            suffix ??
            (widget.suffixIconBuilder != null && cnt != null
                ? widget.suffixIconBuilder!(cnt)
                : widget.suffixIcon),
        hintText: widget.hintText,
        hintStyle:
            (widget.hintStyle ??
            TextStyle(
              color: cgrey,
              fontWeight: FontWeight.w500,
              height: fh16,
              letterSpacing: ls02,
              fontSize: fs16,
            )),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp(
            r'[\u{1F600}-\u{1F64F}' // Emoticons
            r'\u{1F300}-\u{1F5FF}' // Symbols & Pictographs
            r'\u{1F680}-\u{1F6FF}' // Transport & Map
            r'\u{1F700}-\u{1F77F}' // Alchemical Symbols
            r'\u{1F780}-\u{1F7FF}' // Geometric Shapes
            r'\u{1F800}-\u{1F8FF}' // Supplemental Arrows
            r'\u{1F900}-\u{1F9FF}' // Supplemental Symbols
            r'\u{1FA00}-\u{1FA6F}' // Chess Symbols
            r'\u{1FA70}-\u{1FAFF}' // Symbols & Pictographs 2
            r'\u{2600}-\u{26FF}' // Misc symbols
            r'\u{2700}-\u{27BF}' // Dingbats
            r']',
            unicode: true,
          ),
        ),
      ],
    );
  }

  void acceptOnlySuggestionValue(
    TextEditingController textEditingController,
    FocusNode focusNode,
    List<InputValue> suggestionData,
    String? selectData,
  ) {
    if (widget.showMultiSelectAddBtn == true &&
        widget.showMultipleSelect == true &&
        textEditingController.text.isEmpty) {
      return;
    }
    focusNode.unfocus();
    if (widget.suggestionRequired == true) {
      bool flag = false;
      for (var e in suggestionData) {
        // print("TextField:${textEditingController.value.selection}");
        // print(e.text.toLowerCase() == textEditingController.text.toLowerCase());
        if (e.text.toLowerCase() == selectData?.toLowerCase().trim()) {
          textEditingController.text = selectData?.trim() ?? '';
          flag = true;
          break;
        }
      }
      if (flag) {
        return;
      } else {
        if (widget.onChanged != null) {
          widget.onChanged!('');
        }
        textEditingController.clear();
      }
      // final s = suggestionData
      //     .map((e) => e.text.toLowerCase())
      //     .toList()
      //     .contains(textEditingController.text.toLowerCase());
      // if (s) {
      //   return;
      // }
      // textEditingController.clear();
    } else {
      if (selectData != null) {
        textEditingController.text = selectData;
      }
    }
  }

  String? textFieldValidating(String? v) {
    if (widget.dropdownButton == true && widget.notValidate != true) {
      if (multiValue.isEmpty && widget.showMultipleSelect == true) {
        return "Please enter ${widget.lable ?? 'Input Box'}.";
      } else {
        if (widget.notValidate != true && widget.showMultipleSelect != true) {
          if (v == null || v.isEmpty) {
            return "Please enter ${widget.lable ?? 'Input Box'}.";
          }
        }
        return null;
      }
    }
    if (widget.notValidate == true && v!.isEmpty) {
      return null;
    } else {
      if (widget.validator != null) {
        return validatorText(widget.validator!, v);
      } else {
        if (v!.isEmpty) {
          return "Please enter ${widget.lable ?? 'Input Box'}.";
        }
        return null;
      }
    }
  }

  String? validatorText(InputValidator val, String? value) {
    switch (val) {
      case InputValidator.gst:
        if (value == null || value.isEmpty) {
          return 'Please enter GST number';
        }
        if (value.toUpperCase() != widget.controller?.text) {
          return "Please Enter Value in UpperCase Like ABCDEFG.";
        }
        final RegExp gstRegExp = RegExp(
          r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}\d[Z]{1}[A-Z\d]{1}$',
        );
        // GSTIN of Google India : 37AACCG0527D1Z3
        if (!gstRegExp.hasMatch(widget.controller?.text ?? value)) {
          return 'Invalid GST number.';
        }
        return null;
      case InputValidator.pan:
        if (value == null || value.isEmpty) {
          return 'Please enter PAN number';
        }
        if (value.toUpperCase() != widget.controller?.text) {
          return "Please Enter Value in UpperCase Like ABCDEFG.";
        }
        final RegExp panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
        // example: AAAAA3333X
        if (!panRegExp.hasMatch(widget.controller?.text ?? value)) {
          return 'Invalid PAN number';
        }
        return null;
      case InputValidator.email:
        if (value == null || value.isEmpty) {
          return 'Please enter email address';
        }
        final RegExp emailRegExp = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$',
        );
        if (!emailRegExp.hasMatch(value)) {
          return 'Invalid email address';
        }
        return null;
      case InputValidator.webUrl:
        if (value == null || value.isEmpty) {
          return 'Please enter URL';
        }
        final RegExp urlRegExp = RegExp(r'^[^\s/$.?#].[^\s]*$');
        if (!urlRegExp.hasMatch(value)) {
          return 'Invalid URL';
        }
        return null;
      default:
        return null;
    }
  }
}
