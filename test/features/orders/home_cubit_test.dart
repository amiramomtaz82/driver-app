import 'package:bloc_test/bloc_test.dart';
import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/base_response/base_response.dart';
import 'package:driver_app/core/pagination/paginated_response.dart';
import 'package:driver_app/core/pagination/pagination_model.dart';
import 'package:driver_app/features/orders/domain/entities/available_order_entity.dart';
import 'package:driver_app/features/orders/domain/use_cases/accept_order_use_case.dart';
import 'package:driver_app/features/orders/domain/use_cases/get_available_orders_use_case.dart';
import 'package:driver_app/features/orders/presentation/home/manager/home_cubit.dart';
import 'package:driver_app/features/orders/presentation/home/manager/home_intents.dart';
import 'package:driver_app/features/orders/presentation/home/manager/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAvailableOrdersUseCase extends Mock
    implements GetAvailableOrdersUseCase {}

class MockAcceptOrderUseCase extends Mock implements AcceptOrderUseCase {}

const _order = AvailableOrderEntity(
  id: 'order-1',
  orderNumber: '123456',
  totalAmount: 3000,
  currency: 'EGP',
  storeName: 'Flowery store',
  storeAddress: 'Giza',
  recipientName: 'Nour',
  recipientAddress: 'Cairo',
);

SuccessResponse<PaginatedResponse<AvailableOrderEntity>> _pageWith(
  List<AvailableOrderEntity> orders,
) {
  return SuccessResponse(
    PaginatedResponse<AvailableOrderEntity>(
      data: orders,
      pagination: const PaginationModel(page: 1, hasNextPage: false),
    ),
  );
}

void main() {
  late MockGetAvailableOrdersUseCase getOrders;
  late MockAcceptOrderUseCase acceptOrder;

  setUp(() {
    getOrders = MockGetAvailableOrdersUseCase();
    acceptOrder = MockAcceptOrderUseCase();
  });

  HomeCubit build() => HomeCubit(acceptOrder, getOrders);

  test('initial state is the initial HomeState', () {
    final cubit = build();
    expect(cubit.state, HomeState.initial());
    cubit.close();
  });

  blocTest<HomeCubit, HomeState>(
    'HomeStarted emits loading then success with orders',
    build: () {
      when(
        () => getOrders(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async => _pageWith(const [_order]));
      return build();
    },
    act: (c) => c.onIntent(const HomeStarted()),
    expect: () => [
      isA<HomeState>().having(
        (s) => s.ordersPagination.resource.isLoading,
        'loading',
        true,
      ),
      isA<HomeState>()
          .having((s) => s.ordersPagination.resource.isSuccess, 'success', true)
          .having((s) => s.orders, 'orders', const [_order]),
    ],
  );

  test('OrderAccepted success emits a NavigateReplacementEvent', () async {
    when(
      () => acceptOrder(orderId: any(named: 'orderId')),
    ).thenAnswer((_) async => const SuccessResponse<void>(null));

    final cubit = build();
    expectLater(cubit.eventStream, emits(isA<NavigateReplacementEvent>()));

    cubit.onIntent(const OrderAccepted('order-1'));
  });

  test('OrderAccepted failure emits an error snackbar event', () async {
    when(
      () => getOrders(
        page: any(named: 'page'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => _pageWith(const []));
    when(
      () => acceptOrder(orderId: any(named: 'orderId')),
    ).thenAnswer((_) async => ErrorResponse<void>(errMessage: 'taken'));

    final cubit = build();
    expectLater(
      cubit.eventStream,
      emits(
        isA<ShowSnackBarEvent>().having((e) => e.isError, 'isError', true),
      ),
    );

    cubit.onIntent(const OrderAccepted('order-1'));
  });
}
