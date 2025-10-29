import 'package:flutter/material.dart';
import 'package:expance/core/size_utils.dart';

class ListViewPaginated<T> extends StatefulWidget {
  final List<T>? data;
  final int? itemsPerPage;
  final Widget Function(BuildContext, int index, T item) itemBuilder;
  final ScrollPhysics? physics;
  final Widget? simmer;
  final bool? shrinkWrap;

  ListViewPaginated({
    required this.data,
    this.itemsPerPage = 10,
    required this.itemBuilder,
    this.physics,
    this.simmer,
    this.shrinkWrap,
  });
  @override
  _ListViewPaginatedState<T> createState() => _ListViewPaginatedState<T>();
}

class _ListViewPaginatedState<T> extends State<ListViewPaginated<T>> {
  List<T> _allData = []; // Your whole dataset
  List<T> _paginatedData = [];
  int _currentPage = 0;
  int _itemsPerPage = 10;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _itemsPerPage = widget.itemsPerPage ?? 10;
    _allData = widget.data ?? [];

    _loadMoreData(); // Load initial data
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        _loadMoreData(); // Load more data when scrolled to the bottom
      }
    });
  }

  @override
  didUpdateWidget(covariant ListViewPaginated<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("dididUpdateWidget Called===============================");
    _allData = widget.data ?? [];
    _paginatedData = [];
    _currentPage = 0;
    _loadMoreData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    _isLoading = true;

    // Simulate network delay or heavy computation
    // await Future.delayed(Duration(seconds: 2));

    final int startIndex = _currentPage * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;

    if (startIndex < _allData.length) {
      _paginatedData.addAll(
        _allData.sublist(
          startIndex,
          endIndex > _allData.length ? _allData.length : endIndex,
        ),
      );
      _currentPage++;
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("All Data========================${_allData.length}");
    return ListView.builder(
      controller: _scrollController,
      itemCount: _paginatedData.length + (_isLoading ? 1 : 0),
      physics: widget.physics,
      // addRepaintBoundaries: true,
      cacheExtent: size.height * 2,
      // addAutomaticKeepAlives: true,
      // addRepaintBoundaries: false,
      shrinkWrap: widget.shrinkWrap ?? false,
      itemBuilder: (context, index) {
        if ((widget.data ?? []).isEmpty) {
          return widget.simmer ?? SizedBox.shrink();
        }
        return widget.itemBuilder(context, index, _paginatedData[index]);
        // return Column(
        //   children: [
        //     widget.itemBuilder(context, index, _paginatedData[index]),
        //     if (index == _paginatedData.length)
        //       // This is the loading indicator at the bottom
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Center(
        //           child:
        //               _allData.length == _paginatedData.length
        //                   ? Text('No more data to load.')
        //                   : CircularProgressIndicator(),
        //         ),
        //       ),
        //   ],
        // );
      },
    );
  }
}
