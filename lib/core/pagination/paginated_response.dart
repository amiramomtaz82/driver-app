import 'pagination_model.dart';

class PaginatedResponse<T> {
  const PaginatedResponse({required this.data, required this.pagination});

  final List<T> data;
  final PaginationModel pagination;
}
