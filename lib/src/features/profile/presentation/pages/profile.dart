import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  // final UserEntity user;
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: _buildTopBar(
          context: context,
          onTap: () {},
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 24),
              _buildInfoUser(context),
              // _buildSignoutButton(() {
              //   print(context.read<AuthBloc>().state);
              // }),
              SizedBox(height: 24),

              _buildSection(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Cài đặt',
                        style: AppTypography.headlineSmall(),
                      ),
                    ),
                    _buildItem(
                      title: "Chế độ tối",
                      onTap: () {},
                      leadingIcon: const Icon(
                        Icons.dark_mode_outlined,
                        color: AppColors.primary,
                      ),
                      endIcon: Switch(
                        value: false,
                        onChanged: (value) {
                          !value;
                        },
                      ),
                    ),
                    Divider(),
                    _buildItem(
                      title: "Thông báo",
                      onTap: () {},
                      leadingIcon: const Icon(
                        Icons.notifications_none_outlined,
                        color: AppColors.primary,
                      ),
                      endIcon: Switch(
                        value: false,
                        onChanged: (value) {
                          !value;
                        },
                      ),
                    ),
                    Divider(),
                    _buildItem(
                      title: "Lịch sử làm bài",
                      onTap: () {},
                      leadingIcon: const Icon(
                        Icons.history_outlined,
                        color: AppColors.primary,
                      ),
                      endIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
              _buildSection(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tài khoản',
                        style: AppTypography.headlineSmall(),
                      ),
                    ),
                    _buildItem(
                      title: "Đổi mật khẩu",
                      onTap: () {},
                      leadingIcon: const Icon(
                        Icons.lock_outlined,
                        color: AppColors.primary,
                      ),
                      endIcon: Switch(
                        value: false,
                        onChanged: (value) {
                          !value;
                        },
                      ),
                    ),
                    Divider(),
                    
                    _buildItem(
                      title: "Đăng xuất",
                      onTap: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      leadingIcon: const Icon(
                        Icons.logout_outlined,
                        color: AppColors.borderWrong,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignoutButton(VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onTap,
        child: const Text("Sign outs"),
      ),
    );
  }

  PreferredSizeWidget _buildTopBar({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget icon,
  }) {
    double heightTopBar = MediaQuery.sizeOf(context).height * (1 / 10);
    return PreferredSize(
      preferredSize: Size.fromHeight(heightTopBar),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: heightTopBar,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(30),
          //   bottomRight: Radius.circular(30),
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Cá nhân",
                style: AppTypography.headlineMedium().copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: icon),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoUser(BuildContext contextRoot) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (contextRoot, state) {
        // print(state);
        if (state is GuestModeActive) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 80, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start ,
                  children: [
                    Text(
                      (state.guestUser.displayName?.isEmpty ?? true)
                          ? "Khách"
                          : state.guestUser.displayName!,
                      style: AppTypography.headlineSmall().copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      state.guestUser.email?.isEmpty ?? true
                          ? ""
                          : state.guestUser.email!,
                      style: AppTypography.bodyMedium(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildSection({Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: child ?? Container(),
    );
  }

  Widget _buildItem({
    required title,
    required VoidCallback onTap,
    Widget? leadingIcon,
    Widget? endIcon,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    leadingIcon ?? Container(),
                    const SizedBox(width: 8),
                    Text(title, style: AppTypography.bodyMedium()),
                  ],
                ),
              ),
              endIcon ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
