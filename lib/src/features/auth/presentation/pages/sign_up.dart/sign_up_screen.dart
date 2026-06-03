import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_mater_apllication/app/di/injection_container.dart';
import 'package:quiz_mater_apllication/src/core/constants/AppAssets/app_asset.dart';
import 'package:quiz_mater_apllication/src/core/router/app_router.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_colors.dart';
import 'package:quiz_mater_apllication/src/core/theme/app_typography.dart';
import 'package:quiz_mater_apllication/src/core/utils/app_validator.dart';
import 'package:quiz_mater_apllication/src/features/auth/data/services/auth_service.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/signup_request.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_up/sign_up_cubit.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/sign_up/sign_up_state.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/widgets/social_login_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<SignUpCubit, SignUpState>(
          builder: (BuildContext context, state) {
            log(state.toString());
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeader(),
                      SizedBox(height: 16),
                      _buildSignupForm(),
                      SizedBox(height: 16),
                      _buildButtonSignup(() async {
                        if (_formKey.currentState!.validate()) {
                          final signupRequest = SignupRequest(
                            email: emailController.text,
                            password: passwordController.text,
                            userName: userNameController.text,
                          );
                          context.read<SignUpCubit>().signUp(signupRequest);
                        }
                      }),
                      SizedBox(height: 16),
                      _buildDivider(),
                      SizedBox(height: 16),
                      SocialLoginButton(
                        text: 'Đăng ký với Google',
                        iconPath: AppAssetIcon.google,
                        onTap: () {
                          log('Sign up with Google');
                          // context.read<SignInCubit>().signInWithGoogle();
                        },
                      ),
                      SizedBox(height: 16),
                      _buildFooter(onTap: () => context.push(AppRouter.signin)),
                    ],
                  ),
                ),
                if (state is SignUpLoading)
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
              ],
            );
          },
          listener: (BuildContext context, state) {
            if (state is SignUpError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.borderWrong,
                ),
              );
            } else if (state is SignUpSuccess) {
              context.read<AuthBloc>().add(UserLoggedIn(state.user));
            }
          },
        ),
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
            'hoặc đăng ký với',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
      ],
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
          Text('Tạo tài khoản', style: AppTypography.headlineLarge()),
          SizedBox(height: 8),
          Text(
            'Tham gia Quiz Master để bắt đầu luyện thi hiệu quả!',
            style: AppTypography.labelSmall(),
          ),
          SizedBox(height: 16),
          // Image.asset(
          //   AppAssetImage.signinImage,
          //   width: 100,
          //   height: 100,
          //   // fit: BoxFit.fill,
          // ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Container(
      // padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              controller: userNameController,
              validator: AppValidator.validateName,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person_outlined,
                  color: AppColors.textHint,
                ),
                hintText: 'Họ và tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: emailController,
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
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              obscureText: isHiddenPassword,
              controller: passwordController,
              validator: AppValidator.validatePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: AppColors.textHint,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHiddenPassword = !isHiddenPassword;
                    });
                  },
                  icon: isHiddenPassword
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                        )
                      : Icon(
                          Icons.visibility_outlined,
                          color: AppColors.textHint,
                        ),
                ),
                hintText: 'Mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: isHiddenConfirmPassword,
              validator: (value) => AppValidator.validateConfirmPassword(
                value,
                passwordController.text,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outlined,
                  color: AppColors.textHint,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHiddenConfirmPassword = !isHiddenConfirmPassword;
                    });
                  },
                  icon: isHiddenConfirmPassword
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                        )
                      : Icon(
                          Icons.visibility_outlined,
                          color: AppColors.textHint,
                        ),
                ),
                hintText: 'Xác nhận mật khẩu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSignup(VoidCallback onTap) {
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
          'Tạo tài khoản',
          style: AppTypography.bodyLarge().copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter({required VoidCallback onTap}) {
    return Container(
      // padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Đã có tài khoản?', style: AppTypography.labelSmall()),
          TextButton(
            onPressed: onTap,
            child: Text(
              ' Đăng nhập ngay',
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
