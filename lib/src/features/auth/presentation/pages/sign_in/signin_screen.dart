import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/widgets/social_login_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng nhập thất bại: ${state.message}')),
              );
            }
          },
          builder: (BuildContext context, AuthState state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 24),
                      _buildHeader(),
                      // Expanded(child: Image.asset(AppAssetImage.signinImage, fit: BoxFit.cover, )),
                      SizedBox(height: 24),
                      _buildSignInForm(context),
                      // SizedBox(height: 14),
                      _buildFooter(onTap: () => context.push(AppRouter.signup)),
                      // SizedBox(height: 14),
                    ],
                  ),
                ),
                if (state is AuthLoading)
                  Center(
                    child: Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssetIcon.gradurationCap,
            width: 100,
            height: 100,
            colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
          ),
          Text(
            'Quiz Master',
            style: AppTypography.displayLarge().copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Luyện thi thông minh, chinh phục ước mơ',
            style: AppTypography.labelSmall(),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Center(
              child: Text('Đăng nhập', style: AppTypography.headlineSmall()),
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.textHint),
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // filled: true,
              // fillColor: AppColors.surfaceVariant,
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: passwordController,
            obscureText: isHiddenPassword,

            // obscuringCharacter: '*',
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outlined, color: AppColors.textHint),
              suffixIcon: IconButton(
                icon: Icon(
                  isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textHint,
                ),
                onPressed: () {
                  setState(() {
                    isHiddenPassword = !isHiddenPassword;
                  });
                },
              ),

              hintText: 'Mật khẩu',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // filled: true,
              // fillColor: AppColors.surfaceVariant,
            ),
          ),
          SizedBox(height: 20),
          _buildSignInHelper(),
          SizedBox(height: 16),
          _buildSigninButton(
            onTap: () async {
              context.read<AuthBloc>().add(
                SigninWithEmailRequested(
                  signinRequest: SigninRequest(
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 32),
          _buildDivider(),
          SizedBox(height: 16),

          SocialLoginButton(
            text: 'Tiếp tục với Google',
            iconPath: AppAssetIcon.google,
            onTap: () {},
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AnonymousSignInRequested());
            },
            child: Center(
              child: Text(
                'Tiếp tục với tư cách khách',
                style: TextStyle(color: Colors.grey[600], fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSigninButton({required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        child: Text(
          'Đăng nhập',
          style: AppTypography.bodyLarge().copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInHelper() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
              Text('Ghi nhớ đăng nhập', style: AppTypography.bodyMedium()),
            ],
          ),
          // Spacer(),
          Text(
            'Quên mật khẩu?',
            style: AppTypography.bodyMedium().copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'hoặc đăng nhập với',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
      ],
    );
  }

  Widget _buildFooter({required VoidCallback onTap}) {
    return Container(
      // padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Chưa có tài khoản?', style: AppTypography.labelSmall()),
          TextButton(
            onPressed: onTap,
            child: Text(
              ' Đăng ký ngay',
              style: AppTypography.labelMedium().copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
