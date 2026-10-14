import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/pagination/presentation/pagination_footer.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../manager/order_history_cubit.dart';
import '../manager/order_history_intents.dart';
import '../manager/order_history_state.dart';
import '../widgets/order_history_card.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<OrderHistoryCubit>().onIntent(const OrderHistoryStarted());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<OrderHistoryCubit>().onIntent(const OrderHistoryLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                LocaleKeys.orders_my_orders.tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Expanded(
              child: _OrderHistoryBody(scrollController: _scrollController),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHistoryBody extends StatelessWidget {
  const _OrderHistoryBody({required this.scrollController});

  final ScrollController scrollController;

  Future<void> _refresh(BuildContext context) async {
    context.read<OrderHistoryCubit>().onIntent(const OrderHistoryRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
      builder: (context, state) {
        final pagination = state.pagination;
        final orders = state.orders;

        if (pagination.resource.isLoading && orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (pagination.resource.isError && orders.isEmpty) {
          return _MessageWithRetry(
            message:
                pagination.resource.errorMessage?.tr() ??
                LocaleKeys.errors_something_went_wrong.tr(),
            onRetry: () => _refresh(context),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ListView.separated(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: orders.isEmpty ? 1 : orders.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (orders.isEmpty) {
                return _EmptyState(
                  message: LocaleKeys.orders_recent_orders.tr(),
                );
              }

              if (index == orders.length) {
                return PaginationFooter(
                  isLoadingMore: pagination.isLoadingMore,
                  hasNextPage: pagination.hasNextPage,
                  loadMoreError: pagination.loadMoreError,
                  onRetry: () => context.read<OrderHistoryCubit>().onIntent(
                    const OrderHistoryRetried(),
                  ),
                );
              }

              return OrderHistoryCard(order: orders[index]);
            },
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class _MessageWithRetry extends StatelessWidget {
  const _MessageWithRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onRetry,
                child: Text(LocaleKeys.common_retry.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
