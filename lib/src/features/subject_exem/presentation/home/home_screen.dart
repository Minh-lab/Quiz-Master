import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({super.key, required this.navigationShell});
  void _onTap({required int index, required BuildContext contextModelSheet}) {
    final AuthBloc authBloc = sl<AuthBloc>();
    print(authBloc.hashCode);
    final state = authBloc.state;
    if (state is GuestModeActive || state is AuthSuccess) {
      navigationShell.goBranch(
        index,

        initialLocation: index == navigationShell.currentIndex,
      );
    } else {
      showModalBottomSheet(
        context: contextModelSheet,
        builder: (contextModelSheet) {
          final colorScheme = Theme.of(contextModelSheet).colorScheme;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    AppAssetIcon.security,
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Đăng nhập để xem hồ sơ và lịch sử làm bài của bạn',
                    style: AppTypography.headlineMedium(),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.pop(contextModelSheet); // Pop bottom sheet first
                    contextModelSheet.push(AppRouter.signin);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        'Đăng nhập/ Đăng ký ngay',
                        textAlign: TextAlign.center,
                        style: AppTypography.headlineSmall().copyWith(
                            color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(contextModelSheet);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),

                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme.surfaceContainerHigh,
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Center(
                        child: Text(
                          'Để sau',
                          style: AppTypography.headlineMedium().copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          _onTap(index: index, contextModelSheet: context);
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Đề thi'),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}
