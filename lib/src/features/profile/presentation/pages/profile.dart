import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:quiz_mater_apllication/src/core/theme/bloc/theme_cubit.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy màu text dựa trên theme (Hỗ trợ Dark Mode / Light Mode)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Cá nhân",
          style: AppTypography.headlineMedium().copyWith(color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.settings_outlined, color: Colors.white),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildUserInfo(context, textColor),
            const SizedBox(height: 32),
            _buildLearningSection(context, textColor),
            const SizedBox(height: 16),
            _buildSettingsSection(context, textColor),
            const SizedBox(height: 16),
            _buildAccountSection(context, textColor),
            const SizedBox(height: 16),
  
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, Color textColor) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          final String name = (state.user.displayName?.isEmpty ?? true)
              ? "Khách"
              : state.user.displayName!;
          final String initial = name.isNotEmpty
              ? name.substring(0, 1).toUpperCase()
              : "K";
          final String email = state.user.email ?? "";

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 16,
                    
                    backgroundColor: Colors.white24,
                    backgroundImage: state.user.photoUrl != null
                        ? NetworkImage(state.user.photoUrl!,)
                        : null,
                    
                    child: state.user.photoUrl == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          )
                        : null,
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.headlineSmall().copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (email.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: AppTypography.bodyMedium().copyWith(
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: () => context.push('/profile/edit'),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Không có thông tin người dùng',
            style: AppTypography.bodyMedium().copyWith(color: textColor),
          ),
        );
      },
    );
  }

  Widget _buildLearningSection(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Học tập',
            style: AppTypography.headlineSmall().copyWith(color: textColor),
          ),
        ),
        _buildListTile(
          title: "Lịch sử làm bài",
          leadingIcon: Icons.history_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () => context.push('/profile/exam-history'),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildListTile(
          title: "Sổ lỗi sai",
          leadingIcon: Icons.menu_book_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () => context.push('/profile/wrong-answers'),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildListTile(
          title: "Đề đã lưu",
          leadingIcon: Icons.bookmark_outline,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () => context.push('/profile/saved-exams'),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildListTile(
          title: "Thống kê học tập",
          leadingIcon: Icons.bar_chart_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () => context.push('/profile/learning-statistics'),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Hỗ trợ',
            style: AppTypography.headlineSmall().copyWith(color: textColor),
          ),
        ),
        _buildListTile(
          title: "Điều khoản sử dụng",
          leadingIcon: Icons.description_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () {},
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildListTile(
          title: "Chính sách bảo mật",
          leadingIcon: Icons.privacy_tip_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () {},
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildListTile(
          title: "Góp ý / Báo lỗi",
          leadingIcon: Icons.feedback_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
          onTap: () {},
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Cài đặt',
            style: AppTypography.headlineSmall().copyWith(color: textColor),
          ),
        ),
        BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            final isDarkMode =
                themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    MediaQuery.platformBrightnessOf(context) ==
                        Brightness.dark);
            return _buildListTile(
              title: "Chế độ tối",
              leadingIcon: Icons.dark_mode_outlined,
              iconColor: AppColors.primary,
              textColor: textColor,
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
                activeColor: AppColors.primary,
              ),
            );
          },
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        // _buildListTile(
        //   title: "Thông báo",
        //   leadingIcon: Icons.notifications_none_outlined,
        //   iconColor: AppColors.primary,
        //   textColor: textColor,
        //   trailing: Switch(
        //     value: false,
        //     onChanged: (value) {},
        //     activeColor: AppColors.primary,
        //   ),
        // ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        // _buildListTile(
        //   title: "Ngôn ngữ",
        //   leadingIcon: Icons.language_outlined,
        //   iconColor: AppColors.primary,
        //   textColor: textColor,
        //   trailing: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text('Tiếng Việt', style: TextStyle(color: textColor.withOpacity(0.6))),
        //       const SizedBox(width: 8),
        //       Icon(Icons.arrow_forward_ios_outlined, size: 16, color: textColor.withOpacity(0.5)),
        //     ],
        //   ),
        //   onTap: () {},
        // ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Tài khoản',
            style: AppTypography.headlineSmall().copyWith(color: textColor),
          ),
        ),
        _buildListTile(
          title: "Đổi mật khẩu",
          leadingIcon: Icons.lock_outlined,
          iconColor: AppColors.primary,
          textColor: textColor,
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
            color: textColor.withOpacity(0.5),
          ),
          onTap: () => context.push('/profile/change-password'),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
        _buildListTile(
          title: "Đăng xuất",
          leadingIcon: Icons.logout_outlined,
          iconColor: AppColors.borderWrong,
          textColor: AppColors.borderWrong,
          onTap: () => _showLogoutDialog(context),
        ),
        const Divider(height: 1, indent: 20, endIndent: 20),
      ],
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData leadingIcon,
    required Color iconColor,
    required Color textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(leadingIcon, color: iconColor),
      title: Text(
        title,
        style: AppTypography.bodyMedium().copyWith(
          color: textColor,
          fontSize: 16,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : Colors.black;

        return AlertDialog(
          title: Text(
            "Xác nhận đăng xuất",
            style: AppTypography.headlineSmall().copyWith(color: textColor),
          ),
          content: Text(
            "Bạn có chắc chắn muốn đăng xuất?",
            style: AppTypography.bodyMedium().copyWith(color: textColor),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text("Hủy", style: TextStyle(color: textColor)),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Đăng xuất",
                style: TextStyle(
                  color: AppColors.borderWrong,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
