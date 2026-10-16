import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/core/pagination/paginated_response.dart';
import 'package:driver_app/core/pagination/pagination_model.dart';
import 'package:driver_app/features/orders/domain/entities/available_order_entity.dart';
import 'package:driver_app/features/orders/domain/repo/orders_repo.dart';
import 'package:driver_app/features/orders/domain/use_cases/accept_order_use_case.dart';
import 'package:driver_app/features/orders/domain/use_cases/get_available_orders_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepo extends Mock implements OrdersRepo {}

void main() {
  late MockOrdersRepo repo;

  setUp(() => repo = MockOrdersRepo());

  group('GetAvailableOrdersUseCase', () {
    test('delegates to the repo with the given page args', () async {
      const response = SuccessResponse(
        PaginatedResponse<AvailableOrderEntity>(
          data: [],
          pagination: PaginationModel(),
        ),
      );
      when(
        () => repo.getAvailableOrders(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async => response);

      final result = await GetAvailableOrdersUseCase(repo)(page: 2, pageSize: 10);

      expect(result, response);
      verify(() => repo.getAvailableOrders(page: 2, pageSize: 10)).called(1);
    });
  });

  group('AcceptOrderUseCase', () {
    test('delegates to the repo with the given order id', () async {
      const response = SuccessResponse<void>(null);
      when(
        () => repo.acceptOrder(orderId: any(named: 'orderId')),
      ).thenAnswer((_) async => response);

      final result = await AcceptOrderUseCase(repo)(orderId: 'order-1');

      expect(result, response);
      verify(() => repo.acceptOrder(orderId: 'order-1')).called(1);
    });
  });
}
