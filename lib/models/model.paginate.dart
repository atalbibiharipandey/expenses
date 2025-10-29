class ModelPaginate<T> {
  List<T>? data;
  int? currentPage;
  int? currentPageItems;
  int? limit;
  int? totalPages;
  int? totalItems;
  String? previousPage;
  String? currentUrl;
  String? nextPage;

  ModelPaginate({
    this.data,
    this.currentPage,
    this.currentPageItems,
    this.limit,
    this.totalPages,
    this.totalItems,
    this.previousPage,
    this.nextPage,
    this.currentUrl,
  });

  factory ModelPaginate.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) => ModelPaginate(
    data: json["data"] == null
        ? []
        : List<T>.from(json["data"].map((x) => fromJsonT(x))),
    currentPage: json["currentPage"],
    currentPageItems: json["currentPageItems"],
    limit: json["limit"],
    totalPages: json["totalPages"],
    totalItems: json["totalItems"],
    previousPage: json["previousPage"],
    currentUrl: json['currentUrl'],
    nextPage: json["nextPage"],
  );
  List<dynamic> get pages => getPageNumbers();

  List<dynamic> getPageNumbers() {
    if (totalPages == null || totalPages == 0) return [];

    Set<int> pageSet = {};

    // Always include first 2 pages
    pageSet.add(1);
    if (totalPages! >= 2) pageSet.add(2);

    // Add current page ± 2
    if (currentPage != null) {
      for (int i = currentPage! - 2; i <= currentPage! + 2; i++) {
        if (i > 0 && i <= totalPages!) {
          pageSet.add(i);
        }
      }
    }

    // Add last 2 pages
    if (totalPages! > 2) pageSet.add(totalPages! - 1);
    pageSet.add(totalPages!);

    // Convert to sorted list
    List<int> pages = pageSet.toList()..sort();

    // Insert '...' where needed
    List<dynamic> result = [];
    for (int i = 0; i < pages.length; i++) {
      result.add(pages[i]);
      if (i < pages.length - 1 && pages[i + 1] != pages[i] + 1) {
        result.add('...');
      }
    }

    return result;
  }

  // final paginate = ModelPaginate(currentPage: 4, totalPages: 10);
  // print(paginate.getPageNumbers());
  // Output: [1, 2, 3, 4, 5, 6, '...', 9, 10]
}
