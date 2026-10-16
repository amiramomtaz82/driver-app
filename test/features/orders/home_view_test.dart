import 'package:driver_app/config/base/ui_events.dart';
import 'package:driver_app/config/resource/resource.dart';
import 'package:driver_app/core/pagination/pagination_state.dart';
import 'package:driver_app/features/orders/domain/entities/available_order_entity.dart';
import 'package:driver_app/features/orders/presentation/home/manager/home_cubit.dart';
import 'package:driver_app/features/orders/presentation/home/manager/home_intents.dart';
import 'package:driver_app/features/orders/presentation/home/manager/home_state.dart';
import 'package:driver_app/features/orders/presentation/home/view/home_view.dart';
import 'package:driver_app/features/orders/presentation/home/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeCubit extends Mock implements HomeCubit {}

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

HomeState _stateWith(Resource<List<AvailableOrderEntity>> resource) {
  return HomeState(
    ordersPagination: PaginationState<AvailableOrderEntity>(
      resource: resource,
      hasNextPage: false,
    ),
  );
}

void main() {
  late MockHomeCubit cubit;

  setUpAll(() => registerFallbackValue(const HomeStarted()));

  setUp(() {
    cubit = MockHomeCubit();
    when(() => cubit.stream).thenAnswer((_) => const Stream<HomeState>.empty());
    when(() => cubit.eventStream).thenAnswer((_) => const Stream<UiEvent>.empty());
    when(() => cubit.close()).thenAnswer((_) async {});
    when(() => cubit.onIntent(any())).thenReturn(null);
  });

  Widget makeTestable() {
    return MaterialApp(
      home: BlocProvider<HomeCubit>.value(value: cubit, child: const HomeView()),
    );
  }

  testWidgets('renders an OrderCard per available order', (tester) async {
    when(() => cubit.state).thenReturn(
      _stateWith(const Resource.success([_order, _order])),
    );

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(OrderCard), findsNWidgets(2));
    expect(find.text('home.title'), findsOneWidget);
  });

  testWidgets('shows the empty message when there are no orders', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(
      _stateWith(const Resource.success(<AvailableOrderEntity>[])),
    );

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.text('home.no_available_orders'), findsOneWidget);
    expect(find.byType(OrderCard), findsNothing);
  });

  testWidgets('shows a loading indicator on first load', (tester) async {
    when(() => cubit.state).thenReturn(
      _stateWith(const Resource.loading()),
    );

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
