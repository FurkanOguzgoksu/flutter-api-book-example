class PageInfo {
  final int? page;
  final int? limit;
  final int? totalPages;
  final bool? previousPage;
  final bool? nextPage;

  PageInfo({
    this.page,
    this.limit,
    this.totalPages,
    this.previousPage,
    this.nextPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      page: json["page"],
      limit: json["limit"],
      totalPages: json["totalPages"],
      previousPage: json["previousPage"],
      nextPage: json["nextPage"],
    );
  }
}
