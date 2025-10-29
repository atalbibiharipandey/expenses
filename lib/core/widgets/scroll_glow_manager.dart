// smart_form.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expance/core/utils/snack_bar.dart';

typedef GlowCallback = Future<void> Function();
typedef Validator = String? Function(String value);

class SmartFormField extends StatefulWidget {
  final String? label;
  final Widget child;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String value)? validator;
  final bool? noValidate;
  final BorderRadius? borderRadius;

  const SmartFormField({
    required this.label,
    this.controller,
    this.validator,
    this.noValidate = false,
    required this.child,
    this.borderRadius,
    super.key,
    this.initialValue,
  });

  @override
  State<SmartFormField> createState() => _SmartFormFieldState();
}

class _SmartFormFieldState extends State<SmartFormField> {
  bool _shouldGlow = false;

  @override
  void didChangeDependencies() {
    // print("SmartFormField didChangeDependencies==========================");
    if (widget.noValidate != true && widget.label != null) {
      SmartFormRegistry.register(
        widget.label!,
        context,
        widget.controller,
        widget.validator,
        widget.noValidate ?? false,
        _glow,
        widget.initialValue,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.noValidate != true && widget.label != null) {
      SmartFormRegistry.removeAt(widget.label!);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SmartFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print("SmartFormField didUpdateWidget==========================");

    if (widget.noValidate != true && widget.label != null) {
      SmartFormRegistry.registerAgain(
        widget.label!,
        context,
        widget.controller,
        widget.validator,
        widget.noValidate ?? false,
        _glow,
        widget.initialValue,
      );
    }
  }

  Future<void> _glow() async {
    if (!mounted) return;
    setState(() => _shouldGlow = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _shouldGlow = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        // border:
        //     shouldGlow
        //         ? Border.all(color: Colors.redAccent, width: 2)
        //         : null,
        // color: cwhite,
        boxShadow: _shouldGlow
            ? [
                BoxShadow(
                  color: Colors.red.withAlpha(80),
                  blurRadius: 12,
                  spreadRadius: 2,
                  blurStyle: BlurStyle.outer,
                ),
              ]
            : [],
        borderRadius: widget.borderRadius,
      ),

      child: widget.child,
    );
  }
}

class _SmartFormEntry {
  final BuildContext context;
  final TextEditingController? controller;
  final Validator? validator;
  final bool noValidate;
  final GlowCallback glow;
  final String? initialValue;

  _SmartFormEntry({
    required this.context,
    required this.controller,
    required this.validator,
    required this.noValidate,
    required this.glow,
    this.initialValue,
  });
}

class SmartFormRegistry {
  static final Map<String, _SmartFormEntry> _registry = {};
  static final List<String> _ids = [];
  static bool showSnackBarFlag = false;
  static final _debounce = Debouncer();
  static void register(
    String id,
    BuildContext context,
    TextEditingController? controller,
    Validator? validator,
    bool noValidate,
    GlowCallback glow,
    String? initialValue,
  ) {
    _registry[id] = _SmartFormEntry(
      context: context,
      controller: controller,
      validator: validator,
      noValidate: noValidate,
      glow: glow,
      initialValue: initialValue,
    );
    _ids.add(id);
  }

  static void registerAgain(
    String id,
    BuildContext context,
    TextEditingController? controller,
    Validator? validator,
    bool noValidate,
    GlowCallback glow,
    String? initialValue,
  ) {
    _registry[id] = _SmartFormEntry(
      context: context,
      controller: controller,
      validator: validator,
      noValidate: noValidate,
      glow: glow,
      initialValue: initialValue,
    );
  }

  static Future<void> validateAndScroll({bool? showSnackbar}) async {
    _debounce.run(
      () => _validateAndScroll(showSnackbar: showSnackbar ?? showSnackBarFlag),
    );
  }

  static Future<void> _validateAndScroll({bool? showSnackbar}) async {
    for (final id in _ids) {
      final entry = _registry[id];
      if (entry == null || entry.noValidate) continue;

      final value = entry.controller?.text ?? entry.initialValue;

      final isValid = (entry.validator?.call(value ?? '') ?? '').isEmpty;

      // print("Value is :- $value and Valid:- $isValid");

      if ((!isValid) && entry.context.mounted) {
        await Scrollable.ensureVisible(
          entry.context,
          duration: const Duration(milliseconds: 400),
          alignment: 0.5,
        );
        FocusScope.of(
          entry.context,
        ).requestFocus(FocusNode()); // close any other keyboard
        FocusScope.of(entry.context).requestFocus(FocusNode()); // reset focus
        entry.controller?.selection = TextSelection.collapsed(
          offset: (value ?? '').length,
        );
        if (showSnackbar == true) {
          Future.delayed(
            Duration(milliseconds: 200),
            () => showSnackBar("$id Field is Required."),
          );
        }
        await entry.glow();
        break;
      }
    }
  }

  static Future<void> validateAndScrollById(
    String? id, {
    bool? showSnackbar,
  }) async {
    if (id == null) return;
    if (_ids.contains(id) == false) {
      print(
        "Scrollable id Not Found. $id Not Present in _ids of validateAndScrollById Function=========",
      );
      return;
    }

    final entry = _registry[id];
    if (entry == null || entry.noValidate) {
      print(
        "entry == null || entry.noValidate is True, so Scrolling not start. Please check==============",
      );
      return;
    }
    ;

    // final value = entry.controller?.text ?? entry.initialValue;
    // final isValid = (entry.validator?.call(value ?? '') ?? '').isEmpty;

    if (entry.context.mounted) {
      await Scrollable.ensureVisible(
        entry.context,
        duration: const Duration(milliseconds: 400),
        alignment: 0.5,
      );
      FocusScope.of(
        entry.context,
      ).requestFocus(FocusNode()); // close any other keyboard
      FocusScope.of(entry.context).requestFocus(FocusNode()); // reset focus
      // entry.controller?.selection = TextSelection.collapsed(
      //   offset: (value ?? '').length,
      // );
      if (showSnackbar == true) {
        Future.delayed(
          Duration(milliseconds: 200),
          () => showSnackBar("$id Field is Required."),
        );
      }
      await entry.glow();
    }
  }

  static void clear() {
    _registry.clear();
    _ids.clear();
  }

  static void removeAt(String id) {
    try {
      _registry.remove(id);
      _ids.remove(id);
      // print(_registry.length);
      // print(_ids.length);
    } catch (e) {
      print("SmartFormRegistry removeAt Function Error:---------------");
      print(e);
    }
  }
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds ?? 300), action);
  }
}
