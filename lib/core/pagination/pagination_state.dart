import 'package:equatable/equatable.dart';

import '../../config/resource/resource.dart';

class PaginationState<T> extends Equatable {
  const PaginationState({
    required this.resource,
    this.currentPage = 0,
    this.hasNextPage = true,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory PaginationState.initial() =>
      PaginationState<T>(resource: const Resource.initial());

  final Resource<List<T>> resource;
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? loadMoreError;

  List<T> get items => resource.data ?? const [];

  PaginationState<T> copyWith({
    Resource<List<T>>? resource,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return PaginationState<T>(
      resource: resource ?? this.resource,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
    resource,
    currentPage,
    hasNextPage,
    isLoadingMore,
    loadMoreError,
  ];
}
