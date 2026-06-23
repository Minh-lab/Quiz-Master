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

  void _onTap({required int index, required BuildContext context}) {
    if (index == 0) {
      _goToBranch(context, index);
      return;
    }

    final state = sl<AuthBloc>().state;
    if (state is AuthSuccess) {
      _goToBranch(context, index);
    } else {
      _showLoginRequiredSheet(context);
    }
  }

  void _goToBranch(BuildContext context, int index) {
    // Để luôn về trang gốc của tab khi ấn Bottom Navigation Bar
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _showLoginRequiredSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssetIcon.security,
                    fit: BoxFit.contain,
                    height: 180,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đăng nhập để xem hồ sơ và lịch sử làm bài của bạn',
                    style: AppTypography.bodyMedium().copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      Navigator.pop(sheetContext);
                      context.push(AppRouter.signin);
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
                          'Đăng nhập / Đăng ký ngay',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium().copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(sheetContext),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.surfaceContainerHigh,
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Center(
                          child: Text(
                            'Để sau',
                            style: AppTypography.bodyMedium().copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(index: index, context: context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Đề thi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}
