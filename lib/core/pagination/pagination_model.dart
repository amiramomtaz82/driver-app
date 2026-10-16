class PaginationModel {
  const PaginationModel({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) => PaginationModel(
    page: json['page'] as int?,
    pageSize: json['pageSize'] as int?,
    totalCount: json['totalCount'] as int?,
    totalPages: json['totalPages'] as int?,
    hasNextPage: json['hasNextPage'] as bool?,
    hasPreviousPage: json['hasPreviousPage'] as bool?,
  );

  final int? page;
  final int? pageSize;
  final int? totalCount;
  final int? totalPages;
  final bool? hasNextPage;
  final bool? hasPreviousPage;
}
