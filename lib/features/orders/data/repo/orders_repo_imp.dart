import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/base_response/base_response.dart';
import '../../../../config/secure_storage/secure_storage.dart';
import '../../../../core/pagination/paginated_response.dart';
import '../../../../core/pagination/pagination_model.dart';
import '../../domain/entities/available_order_entity.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repo/orders_repo.dart';
import '../data_source/orders_remote_data_source.dart';

@Injectable(as: OrdersRepo)
class OrdersRepoImpl implements OrdersRepo {
  OrdersRepoImpl(this._ordersRemoteDataSource, this._secureStorage);

  final OrdersRemoteDataSource _ordersRemoteDataSource;
  final SecureStorage _secureStorage;

  static const bool useDummyData = true;

  @override
  Future<BaseResponse<PaginatedResponse<AvailableOrderEntity>>>
  getAvailableOrders({required int page, required int pageSize}) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 600));
      return SuccessResponse(
        PaginatedResponse<AvailableOrderEntity>(
          data: _dummyOrders,
          pagination: PaginationModel(
            page: page,
            pageSize: pageSize,
            hasNextPage: false,
          ),
        ),
      );
    }
    try {
      final orders = await _ordersRemoteDataSource.getAvailableOrders(
        page: page,
        pageSize: pageSize,
      );

      final pagination = orders.pagination;
      return SuccessResponse(
        PaginatedResponse<AvailableOrderEntity>(
          data: orders.items.map((order) => order.toEntity()).toList(),
          pagination: PaginationModel(
            page: pagination?.page,
            pageSize: pagination?.pageSize,
            totalCount: pagination?.totalCount,
            totalPages: pagination?.totalPages,
            hasNextPage: pagination?.hasNextPage,
            hasPreviousPage: pagination?.hasPreviousPage,
          ),
        ),
      );
    } on DioException catch (e) {
      return ErrorResponse(error: e);
    }
  }

  @override
  Future<BaseResponse<void>> acceptOrder({required String orderId}) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 600));
      await _loadDummyState();
      _dummyStatuses[orderId] = OrderStatus.preparing;
      await _saveDummyState();
      return const SuccessResponse(null);
    }
    try {
      await _ordersRemoteDataSource.acceptOrder(orderId: orderId);
      return const SuccessResponse(null);
    } on DioException catch (e) {
      return ErrorResponse(error: e);
    }
  }

  @override
  Future<BaseResponse<OrderDetailsEntity?>> getActiveOrder() async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 600));
      await _loadDummyState();
      for (final entry in _dummyStatuses.entries) {
        final status = _dummyStatusFor(entry.key);
        final isActive =
            status != OrderStatus.delivered &&
            status != OrderStatus.cancelled &&
            status != OrderStatus.unknown;
        if (isActive) return SuccessResponse(_dummyDetails(entry.key));
      }
      return const SuccessResponse(null);
    }
    try {
      final dto = await _ordersRemoteDataSource.getActiveOrder();
      return SuccessResponse(dto?.toEntity());
    } on DioException catch (e) {
      return ErrorResponse(error: e);
    }
  }

  @override
  Future<BaseResponse<OrderDetailsEntity>> getOrderDetails({
    required String orderId,
  }) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 600));
      await _loadDummyState();
      return SuccessResponse(_dummyDetails(orderId));
    }
    try {
      final dto = await _ordersRemoteDataSource.getOrderDetails(
        orderId: orderId,
      );
      return SuccessResponse(dto.toEntity());
    } on DioException catch (e) {
      return ErrorResponse(error: e);
    }
  }

  @override
  Future<BaseResponse<void>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    if (useDummyData) {
      await Future.delayed(const Duration(milliseconds: 600));
      await _loadDummyState();
      _dummyStatuses[orderId] = newStatus;
      if (newStatus == OrderStatus.awaitingDeliveryConfirmation) {
        _dummyAwaitingSince[orderId] = DateTime.now();
      }
      await _saveDummyState();
      return const SuccessResponse(null);
    }
    final apiValue = newStatus.apiValue;
    if (apiValue == null) {
      return ErrorResponse(errMessage: 'errors.something_went_wrong');
    }
    try {
      await _ordersRemoteDataSource.updateOrderStatus(
        orderId: orderId,
        newStatus: apiValue,
      );
      return const SuccessResponse(null);
    } on DioException catch (e) {
      return ErrorResponse(error: e);
    }
  }

  static final Map<String, OrderStatus> _dummyStatuses = {};

  static final Map<String, DateTime> _dummyAwaitingSince = {};
  static const Duration _dummyCustomerConfirmDelay = Duration(seconds: 8);

  static const String _dummyStateKey = 'dummy_orders_state';
  bool _dummyStateLoaded = false;

  Future<void> _loadDummyState() async {
    if (_dummyStateLoaded) return;
    _dummyStateLoaded = true;
    final raw = await _secureStorage.read(key: _dummyStateKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final statuses = map['statuses'] as Map<String, dynamic>? ?? {};
      final awaiting = map['awaitingSince'] as Map<String, dynamic>? ?? {};
      statuses.forEach((id, name) {
        _dummyStatuses[id] = OrderStatus.values.firstWhere(
          (s) => s.name == name,
          orElse: () => OrderStatus.preparing,
        );
      });
      awaiting.forEach((id, iso) {
        final parsed = DateTime.tryParse(iso as String? ?? '');
        if (parsed != null) _dummyAwaitingSince[id] = parsed;
      });
    } catch (_) {}
  }

  Future<void> _saveDummyState() async {
    final payload = {
      'statuses': _dummyStatuses.map((id, s) => MapEntry(id, s.name)),
      'awaitingSince': _dummyAwaitingSince.map(
        (id, t) => MapEntry(id, t.toIso8601String()),
      ),
    };
    await _secureStorage.write(key: _dummyStateKey, value: jsonEncode(payload));
  }

  OrderStatus _dummyStatusFor(String orderId) {
    final status = _dummyStatuses[orderId] ?? OrderStatus.preparing;
    if (status == OrderStatus.awaitingDeliveryConfirmation) {
      final since = _dummyAwaitingSince[orderId];
      if (since != null &&
          DateTime.now().difference(since) >= _dummyCustomerConfirmDelay) {
        _dummyStatuses[orderId] = OrderStatus.delivered;
        _saveDummyState();
        return OrderStatus.delivered;
      }
    }
    return status;
  }

  OrderDetailsEntity _dummyDetails(String orderId) {
    final source = _dummyOrders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => _dummyOrders.first,
    );
    return OrderDetailsEntity(
      id: source.id,
      orderNumber: source.orderNumber,
      status: _dummyStatusFor(orderId),
      createdAt: DateTime(2024, 9, 3, 11),
      total: source.totalAmount,
      currency: source.currency,
      paymentMethod: 'Cash on delivery',
      pickup: OrderPartyEntity(
        name: source.storeName,
        address: source.storeAddress,
        phone: '+201000000000',
      ),
      recipient: OrderPartyEntity(
        name: source.recipientName,
        address: source.recipientAddress,
        phone: '+201111111111',
      ),
      items: const [
        OrderItemEntity(
          name: 'Red roses, 15 Pink Rose Bouquet',
          quantity: 1,
          price: 600,
        ),
        OrderItemEntity(
          name: 'Red roses, 15 Pink Rose Bouquet',
          quantity: 1,
          price: 600,
        ),
      ],
    );
  }

  static const List<AvailableOrderEntity> _dummyOrders = [
    AvailableOrderEntity(
      id: '1',
      orderNumber: '123456',
      totalAmount: 3000,
      currency: 'EGP',
      storeName: 'Flowery store',
      storeAddress: '20th st, Sheikh Zayed, Giza',
      recipientName: 'Nour mohamed',
      recipientAddress: '20th st, Sheikh Zayed, Giza',
    ),
    AvailableOrderEntity(
      id: '2',
      orderNumber: '123457',
      totalAmount: 1500,
      currency: 'EGP',
      storeName: 'Flowery store',
      storeAddress: '15th st, Maadi, Cairo',
      recipientName: 'Omar Khaled',
      recipientAddress: '90th st, New Cairo',
    ),
    AvailableOrderEntity(
      id: '3',
      orderNumber: '123458',
      totalAmount: 750,
      currency: 'EGP',
      storeName: 'Flowery store',
      storeAddress: 'Nasr City, Cairo',
      recipientName: 'Sarah Smith',
      recipientAddress: 'Heliopolis, Cairo',
    ),
  ];
}
