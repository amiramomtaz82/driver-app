import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/core/pagination/paginated_response.dart';
import 'package:driver_app/core/pagination/pagination_model.dart';
import 'package:driver_app/features/orders/domain/entities/order_history_entity.dart';
import 'package:driver_app/features/orders/domain/entities/order_status.dart';
import 'package:driver_app/features/orders/domain/use_cases/get_order_history_use_case.dart';
import 'package:driver_app/features/orders/presentation/order_history/manager/order_history_cubit.dart';
import 'package:driver_app/features/orders/presentation/order_history/manager/order_history_intents.dart';
import 'package:driver_app/features/orders/presentation/order_history/manager/order_history_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOrderHistoryUseCase extends Mock
    implements GetOrderHistoryUseCase {}

const _order = OrderHistoryEntity(
  id: 'order-1',
  orderNumber: '123456',
  status: OrderStatus.delivered,
  storeName: 'Flowery store',
  storeAddress: 'Giza',
  recipientName: 'Nour',
  recipientAddress: 'Cairo',
);

SuccessResponse<PaginatedResponse<OrderHistoryEntity>> _pageWith(
  List<OrderHistoryEntity> orders, {
  bool hasNext = false,
}) {
  return SuccessResponse(
    PaginatedResponse<OrderHistoryEntity>(
      data: orders,
      pagination: PaginationModel(page: 1, hasNextPage: hasNext),
    ),
  );
}

void main() {
  late MockGetOrderHistoryUseCase getHistory;

  setUp(() => getHistory = MockGetOrderHistoryUseCase());

  OrderHistoryCubit build() => OrderHistoryCubit(getHistory);

  test('initial state is the initial OrderHistoryState', () {
    final cubit = build();
    expect(cubit.state, OrderHistoryState.initial());
    cubit.close();
  });

  blocTest<OrderHistoryCubit, OrderHistoryState>(
    'OrderHistoryStarted emits loading then success with orders',
    build: () {
      when(
        () => getHistory(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async => _pageWith(const [_order]));
      return build();
    },
    act: (c) => c.onIntent(const OrderHistoryStarted()),
    expect: () => [
      isA<OrderHistoryState>().having(
        (s) => s.pagination.resource.isLoading,
        'loading',
        true,
      ),
      isA<OrderHistoryState>()
          .having((s) => s.pagination.resource.isSuccess, 'success', true)
          .having((s) => s.orders, 'orders', const [_order]),
    ],
  );

  blocTest<OrderHistoryCubit, OrderHistoryState>(
    'OrderHistoryStarted emits error when the use case fails',
    build: () {
      when(
        () => getHistory(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer(
        (_) async => ErrorResponse<PaginatedResponse<OrderHistoryEntity>>(
          errMessage: 'boom',
        ),
      );
      return build();
    },
    act: (c) => c.onIntent(const OrderHistoryStarted()),
    expect: () => [
      isA<OrderHistoryState>().having(
        (s) => s.pagination.resource.isLoading,
        'loading',
        true,
      ),
      isA<OrderHistoryState>().having(
        (s) => s.pagination.resource.isError,
        'error',
        true,
      ),
    ],
  );

  blocTest<OrderHistoryCubit, OrderHistoryState>(
    'OrderHistoryLoadMore appends the next page',
    build: () {
      when(
        () => getHistory(page: 1, pageSize: any(named: 'pageSize')),
      ).thenAnswer((_) async => _pageWith(const [_order], hasNext: true));
      when(
        () => getHistory(page: 2, pageSize: any(named: 'pageSize')),
      ).thenAnswer((_) async => _pageWith(const [_order]));
      return build();
    },
    act: (c) async {
      c.onIntent(const OrderHistoryStarted());
      await Future<void>.delayed(Duration.zero);
      c.onIntent(const OrderHistoryLoadMore());
    },
    skip: 2,
    expect: () => [
      isA<OrderHistoryState>().having(
        (s) => s.orders.length,
        'appended',
        2,
      ),
    ],
  );
}
