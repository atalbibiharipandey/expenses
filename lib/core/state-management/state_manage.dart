import 'package:flutter/material.dart';

class MV<T> {
  T value;
  final List<VoidCallback> _observers = [];
  bool forceRefresh = false;

  MV(this.value);

  /// Add a new observer
  void addObserver(VoidCallback? state) {
    if (state == null) {
      return;
    }
    if (!_observers.contains(state)) {
      _observers.add(state);
    }
  }

  /// Remove an observer
  void removeObserver(VoidCallback? state) {
    if (state == null) {
      return;
    }
    _observers.remove(state);
    // print(_observers);
  }

  /// Notify all observers
  void refresh({bool? force}) {
    if (force == true) {
      forceRefresh = true;
    }
    for (var observer in _observers.toList()) {
      try {
        observer.call(); // Safely notify observer
      } catch (_) {
        _observers.remove(observer); // Remove if observer is invalid
      }
    }
  }
}

class RefreshWidget<T> extends StatefulWidget {
  const RefreshWidget({
    super.key,
    required this.ids,
    required this.builder,
    this.apiData,
    this.shimmer,
  });

  final List<MV> ids;
  final Future<T>? apiData;
  final Widget? shimmer;
  final Widget Function(BuildContext context, T? data) builder;

  @override
  State<RefreshWidget<T>> createState() => _RefreshWidgetState<T>();
}

class _RefreshWidgetState<T> extends State<RefreshWidget<T>> {
  T? d;
  bool loadingApiData = false;
  ValueNotifier<int> valueNotifier = ValueNotifier(0);

  getData() async {
    if (widget.apiData != null && !loadingApiData) {
      loadingApiData = true;
      valueNotifier.value++;
      d = await widget.apiData;
      loadingApiData = false;
      valueNotifier.value++;
    }
  }

  @override
  void initState() {
    super.initState();
    // print("initState Function Called===========");
    for (var e in widget.ids) {
      e.addObserver((_refresh));
    }
    getData();
  }

  @override
  void dispose() {
    for (var e in widget.ids) {
      e.removeObserver((_refresh));
    } // Remove observer to avoid memory leaks
    // print("Dispose Function Called===========Left Observer");
    valueNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RefreshWidget<T> oldWidget) {
    valueNotifier.value++;
    super.didUpdateWidget(oldWidget);
  }

  void _refresh() {
    if (mounted) {
      valueNotifier.value++; // Only update if widget is still in the tree
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        if (widget.apiData != null &&
            widget.shimmer != null &&
            loadingApiData) {
          return widget.shimmer ?? const SizedBox.shrink();
        }
        final c = widget.ids.any((e) => e.forceRefresh == true);
        if (c) {
          for (var e in widget.ids) {
            e.forceRefresh = false;
          }
          WidgetsBinding.instance.addPostFrameCallback((t) async {
            if (widget.shimmer != null) {
              await Future.delayed(Duration(milliseconds: 300));
            }
            valueNotifier.value++;
          });
          return widget.shimmer ?? const SizedBox.shrink();
        }
        return widget.builder(context, d);
      },
    );
  }
}

extension MyRefreshExtension on StateSetter {
  void refresh() {
    return this.call(() {});
  }
}

extension ValueNotifierBool on bool? {
  ValueNotifier<bool> get obx => ValueNotifier(this ?? false);
  bool get noNull => this ?? false;
  MV<bool> get mv => MV(this ?? false);
}

extension ValueNotifierString on String? {
  ValueNotifier<String?> get obx => ValueNotifier(this);
  MV<String?> get mv => MV(this);
}

extension ValueNotifierInt on int? {
  ValueNotifier<int?> get obx => ValueNotifier(this);
  MV<int?> get mv => MV(this);
}

extension ValueNotifierNum on num? {
  ValueNotifier<num?> get obx => ValueNotifier(this);
  MV<num?> get mv => MV(this);
}

extension ValueNotifierDouble on double? {
  ValueNotifier<double?> get obx => ValueNotifier(this);
  MV<double?> get mv => MV(this);
}

extension ValueNotifierList on List? {
  ValueNotifier<List?> get obx => ValueNotifier(this);
  MV<List?> get mv => MV(this);
}

extension MvExtension<T> on T {
  MV<T> get mv => MV(this);
}
