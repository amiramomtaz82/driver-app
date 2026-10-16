import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../core/pagination/presentation/pagination_footer.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../manager/home_cubit.dart';
import '../manager/home_intents.dart';
import '../manager/home_state.dart';
import '../widgets/order_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with UiEventMixin<HomeView, HomeState, UiEvent> {
  final ScrollController _scrollController = ScrollController();

  @override
  BaseCubit<HomeState, UiEvent> get cubit => context.read<HomeCubit>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<HomeCubit>().onIntent(const HomeStarted());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<HomeCubit>().onIntent(const HomeLoadMore());
    }
  }

  Future<void> _onRefresh() async {
    context.read<HomeCubit>().onIntent(const HomeRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                LocaleKeys.home_title.tr(),
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: colors.primary),
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) => _buildBody(context, state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    final pagination = state.ordersPagination;
    final orders = state.orders;

    if (pagination.resource.isLoading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pagination.resource.isError && orders.isEmpty) {
      return _MessageWithRetry(
        message:
            pagination.resource.errorMessage?.tr() ??
            LocaleKeys.errors_something_went_wrong.tr(),
        onRetry: _onRefresh,
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: orders.isEmpty ? 1 : orders.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (orders.isEmpty) {
            return _EmptyState(
              message: LocaleKeys.home_no_available_orders.tr(),
            );
          }

          if (index == orders.length) {
            return PaginationFooter(
              isLoadingMore: pagination.isLoadingMore,
              hasNextPage: pagination.hasNextPage,
              loadMoreError: pagination.loadMoreError,
              onRetry: () =>
                  context.read<HomeCubit>().onIntent(const HomeRetried()),
            );
          }

          final order = orders[index];
          return OrderCard(
            order: order,
            isAccepting: state.acceptingOrderId == order.id,
            isAcceptEnabled: !state.isAccepting,
            onAccept: () =>
                context.read<HomeCubit>().onIntent(OrderAccepted(order.id)),
          );
        },
      ),
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
