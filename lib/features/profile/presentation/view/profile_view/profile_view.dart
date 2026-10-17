import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/base/base_cubit.dart';
import '../../../../../config/base/ui_events.dart';
import '../../../../../config/mixins/ui_event_handler_mixin.dart';
import '../../../../../core/app_theme/context_extension.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../manager/profile_cubit.dart';
import '../../manager/profile_intents.dart';
import '../../manager/profile_state.dart';
import 'widgets/logout_dialog.dart';
import 'widgets/profile_content_list.dart';
import 'widgets/profile_error_view.dart';
import 'widgets/profile_shimmer.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with UiEventMixin<ProfileView, ProfileState, UiEvent> {
  @override
  BaseCubit<ProfileState, UiEvent> get cubit => context.read<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().onIntent(const ProfileStarted());
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => LogoutDialog(
        onConfirm: () => context.read<ProfileCubit>().onIntent(const LogoutConfirmed()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.customColors;

    final textTheme = context.theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,

              icon: const Icon(Icons.arrow_back_ios, size: 20),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            const SizedBox(width:1),
            Text(
              LocaleKeys.profile_title.tr(),
              style: textTheme.headlineLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('3'),
              backgroundColor: colors.primary,
              child: const Icon(Icons.notifications_none_outlined),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        buildWhen: (prev, curr) => prev.profileResource != curr.profileResource,
        builder: (context, state) {
          final resource = state.profileResource;
          if (resource.isLoading && resource.data == null) {
            return const ProfileShimmer();
          }
          if (resource.isError && resource.data == null) {
            return ProfileErrorView(
              errorMessage: resource.errorMessage,
              onRetry: () => context.read<ProfileCubit>().onIntent(const ProfileRefreshed()),
            );
          }
          final profile = resource.data;
          if (profile == null) return const SizedBox.shrink();

          return ProfileContentList(
            profile: profile,
            onLogoutTap: _showLogoutDialog,
          );
        },
      ),
    );
  }
}