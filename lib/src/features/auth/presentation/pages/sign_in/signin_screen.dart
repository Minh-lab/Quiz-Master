import 'dart:developer';
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
import 'package:quiz_mater_apllication/src/core/utils/app_validator.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signin_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_in/sign_in_state.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/widgets/social_login_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
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
        child: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đăng nhập thất bại: ${state.message}')),
              );
            } else if (state is SignInSuccess) {
              context.read<AuthBloc>().add(UserLoggedIn(state.user));
              if (context.mounted) {
                context.go(AppRouter.home);
              }
            }
          },
          builder: (BuildContext context, SignInState state) {
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
                      // SizedBox(height: 24),
                      _buildSignInForm(context),
                      // SizedBox(height: 14),
                      _buildFooter(
                        context: context,
                        onTap: () => context.push(AppRouter.signup),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                      // ,
                    ],
                  ),
                ),
                if (state is SignInLoading)
                  Positioned.fill(
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.1),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
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
      child: Form(
        key: _formKey,
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
            TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: AppValidator.validateEmail,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.textHint,
                ),
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // filled: true,
                // fillColor: AppColors.surfaceVariant,
              ),
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: passwordController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: isHiddenPassword,
              validator: AppValidator.validatePassword,

              // obscuringCharacter: '*',
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: AppColors.textHint,
                ),
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
                FocusScope.of(
                  context,
                ).unfocus(); // Ẩn bàn phím để tránh kẹt giao diện
                if (_formKey.currentState!.validate()) {
                  context.read<SignInCubit>().signIn(
                    SigninRequest(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 32),
            _buildDivider(),
            SizedBox(height: 16),

            SocialLoginButton(
              text: 'Tiếp tục với Google',
              iconPath: AppAssetIcon.google,
              onTap: () {
                FocusScope.of(context).unfocus(); // Ẩn bàn phím
                log('Sign in with Google');
                context.read<SignInCubit>().signInWithGoogle();
              },
            ),
            SizedBox(height: 8),
            // TextButton(
            //   onPressed: () {
            //     context.read<AuthBloc>().add(AnonymousSignInRequested());
            //   },
            //   child: Center(
            //     child: TextButton(
            //       onPressed: () {
            //         context.read<AuthBloc>().add(AnonymousSignInRequested());
            //       },
            //       child: Text(
            //         'Tiếp tục với tư cách khách',
            //         style: AppTypography.labelMedium().copyWith(
            //           color: AppColors.primary,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Row(
          //       children: [
          //         Checkbox(
          //           value: true,
          //           onChanged: (value) {},
          //           activeColor: AppColors.primary,
          //         ),
          //         Text('Ghi nhớ đăng nhập', style: AppTypography.bodyMedium()),
          //       ],
          //     ),

          //     // Spacer(),
          //   ],
          // ),
          GestureDetector(
            onTap: () => context.push(AppRouter.forgotPassword),
            child: Text(
              'Quên mật khẩu?',
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
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

  Widget _buildFooter({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Container(
      // padding: EdgeInsets.only(bottom: 40),
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
