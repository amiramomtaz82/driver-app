import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../../domain/entities/order_status.dart';
import '../manager/order_details_cubit.dart';
import '../manager/order_details_intents.dart';
import '../manager/order_details_state.dart';
import '../widgets/order_action_bar.dart';
import '../widgets/order_details_body.dart';
import '../widgets/order_message_retry.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView>
    with UiEventMixin<OrderDetailsView, OrderDetailsState, UiEvent> {
  @override
  BaseCubit<OrderDetailsState, UiEvent> get cubit =>
      context.read<OrderDetailsCubit>();

  @override
  void initState() {
    super.initState();
    context.read<OrderDetailsCubit>().onIntent(const OrderDetailsStarted());
  }

  @override
  Widget build(BuildContext context) {
    // Locked onto the order: no back to Home until it is complete.
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(LocaleKeys.orders_order_details.tr()),
        ),
        body: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          buildWhen: (prev, curr) =>
              prev.details.status != curr.details.status ||
              (prev.details.data == null) != (curr.details.data == null),
          builder: (context, state) {
            final resource = state.details;
            if (resource.isLoading && resource.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (resource.isError && resource.data == null) {
              return OrderMessageRetry(
                message:
                    resource.errorMessage?.tr() ??
                    LocaleKeys.errors_something_went_wrong.tr(),
                onRetry: () => context.read<OrderDetailsCubit>().onIntent(
                  const OrderDetailsRetried(),
                ),
              );
            }

            final order = resource.data!;
            return Column(
              children: [
                Expanded(child: OrderDetailsBody(order: order)),
                _ActionBarSelector(fallbackStatus: order.status),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Rebuilds only the action bar when the status or the in-flight flag changes.
class _ActionBarSelector extends StatelessWidget {
  const _ActionBarSelector({required this.fallbackStatus});

  final OrderStatus fallbackStatus;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrderDetailsCubit, OrderDetailsState,
        ({OrderStatus status, bool isBusy})>(
      selector: (state) => (
        status: state.details.data?.status ?? fallbackStatus,
        isBusy: state.isUpdatingStatus,
      ),
      builder: (context, data) =>
          OrderActionBar(status: data.status, isBusy: data.isBusy),
    );
  }
}
