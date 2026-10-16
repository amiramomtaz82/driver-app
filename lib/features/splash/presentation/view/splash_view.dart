import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/base/base_cubit.dart';
import '../../../../config/base/ui_events.dart';
import '../../../../config/mixins/ui_event_handler_mixin.dart';
import '../manager/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with UiEventMixin<SplashView, void, UiEvent> {
  @override
  BaseCubit<void, UiEvent> get cubit => context.read<SplashCubit>();

  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().decideStartDestination();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
