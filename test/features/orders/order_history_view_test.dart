import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/pagination/pagination_state.dart';
import 'package:driver_app/features/orders/domain/entities/order_history_entity.dart';
import 'package:driver_app/features/orders/domain/entities/order_status.dart';
import 'package:driver_app/features/orders/presentation/order_history/manager/order_history_cubit.dart';
import 'package:driver_app/features/orders/presentation/order_history/manager/order_history_intents.dart';
import 'package:driver_app/features/orders/presentation/order_history/manager/order_history_state.dart';
import 'package:driver_app/features/orders/presentation/order_history/view/order_history_view.dart';
import 'package:driver_app/features/orders/presentation/order_history/widgets/order_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrderHistoryCubit extends Mock implements OrderHistoryCubit {}

const _order = OrderHistoryEntity(
  id: 'order-1',
  orderNumber: '123456',
  status: OrderStatus.delivered,
  storeName: 'Flowery store',
  storeAddress: 'Giza',
  recipientName: 'Nour',
  recipientAddress: 'Cairo',
);

OrderHistoryState _stateWith(
  Resource<List<OrderHistoryEntity>> resource, {
  bool hasNextPage = false,
}) {
  return OrderHistoryState(
    pagination: PaginationState<OrderHistoryEntity>(
      resource: resource,
      hasNextPage: hasNextPage,
    ),
  );
}

void main() {
  late MockOrderHistoryCubit cubit;

  setUpAll(() => registerFallbackValue(const OrderHistoryStarted()));

  setUp(() {
    cubit = MockOrderHistoryCubit();
    when(
      () => cubit.stream,
    ).thenAnswer((_) => const Stream<OrderHistoryState>.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.onIntent(any())).thenReturn(null);
  });

  Widget makeTestable() {
    return MaterialApp(
      home: BlocProvider<OrderHistoryCubit>.value(
        value: cubit,
        child: const OrderHistoryView(),
      ),
    );
  }

  testWidgets('loads the first page on init', (tester) async {
    when(
      () => cubit.state,
    ).thenReturn(_stateWith(const Resource.success([_order])));

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    verify(
      () => cubit.onIntent(any(that: isA<OrderHistoryStarted>())),
    ).called(1);
  });

  testWidgets('renders a card per order and the title', (tester) async {
    when(
      () => cubit.state,
    ).thenReturn(_stateWith(const Resource.success([_order, _order])));

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(OrderHistoryCard), findsNWidgets(2));
    expect(find.text('orders.my_orders'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no orders', (tester) async {
    when(
      () => cubit.state,
    ).thenReturn(_stateWith(const Resource.success(<OrderHistoryEntity>[])));

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(OrderHistoryCard), findsNothing);
    expect(find.text('orders.recent_orders'), findsOneWidget);
  });

  testWidgets('shows a loading indicator on first load', (tester) async {
    when(() => cubit.state).thenReturn(_stateWith(const Resource.loading()));

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an end-of-list note when there is no next page', (
    tester,
  ) async {
    when(
      () => cubit.state,
    ).thenReturn(_stateWith(const Resource.success([_order])));

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.text('common.no_more_items'), findsOneWidget);
  });

  testWidgets('error state shows retry and refreshes on tap', (tester) async {
    when(() => cubit.state).thenReturn(
      _stateWith(const Resource.error('errors.something_went_wrong')),
    );

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    final retry = find.text('common.retry');
    expect(retry, findsOneWidget);

    await tester.tap(retry);
    await tester.pump();

    verify(
      () => cubit.onIntent(any(that: isA<OrderHistoryRefreshed>())),
    ).called(1);
  });
}
