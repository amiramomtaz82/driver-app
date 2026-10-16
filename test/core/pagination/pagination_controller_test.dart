import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/core/pagination/paginated_response.dart';
import 'package:driver_app/core/pagination/pagination_controller.dart';
import 'package:driver_app/core/pagination/pagination_model.dart';
import 'package:flutter_test/flutter_test.dart';

BaseResponse<PaginatedResponse<int>> _page(int page, {required bool hasNext}) {
  return SuccessResponse(
    PaginatedResponse<int>(
      data: [page * 10],
      pagination: PaginationModel(page: page, hasNextPage: hasNext),
    ),
  );
}

void main() {
  group('PaginationController', () {
    test('initial state is empty and not loading', () {
      final controller = PaginationController<int>(
        fetchPage: (page) async => _page(page, hasNext: true),
      );

      expect(controller.state.items, isEmpty);
      expect(controller.state.isLoadingMore, isFalse);
    });

    test('loadInitialPage populates items and pagination', () async {
      final controller = PaginationController<int>(
        fetchPage: (page) async => _page(page, hasNext: true),
      );

      final state = await controller.loadInitialPage();

      expect(state.resource.isSuccess, isTrue);
      expect(state.items, [10]);
      expect(state.currentPage, 1);
      expect(state.hasNextPage, isTrue);
    });

    test('loadNextPage appends items and advances the page', () async {
      final controller = PaginationController<int>(
        fetchPage: (page) async => _page(page, hasNext: page < 2),
      );

      await controller.loadInitialPage();
      final state = await controller.loadNextPage();

      expect(state.items, [10, 20]);
      expect(state.currentPage, 2);
      expect(state.hasNextPage, isFalse);
    });

    test('loadNextPage is a no-op when there is no next page', () async {
      final controller = PaginationController<int>(
        fetchPage: (page) async => _page(page, hasNext: false),
      );

      await controller.loadInitialPage();
      final state = await controller.loadNextPage();

      expect(state.items, [10]);
      expect(state.currentPage, 1);
    });

    test('loadInitialPage surfaces errors as an error resource', () async {
      final controller = PaginationController<int>(
        fetchPage: (_) async =>
            ErrorResponse<PaginatedResponse<int>>(errMessage: 'boom'),
      );

      final state = await controller.loadInitialPage();

      expect(state.resource.isError, isTrue);
      expect(state.resource.errorMessage, 'boom');
    });

    test('reset clears the accumulated state', () async {
      final controller = PaginationController<int>(
        fetchPage: (page) async => _page(page, hasNext: true),
      );

      await controller.loadInitialPage();
      controller.reset();

      expect(controller.state.items, isEmpty);
      expect(controller.state.currentPage, 0);
    });
  });
}
