import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/domain/entities/user.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:quiz_mater_apllication/src/features/auth/presentation/bloc/auth_event.dart';

class ProfileScreen extends StatelessWidget {
  // final UserEntity user;
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: _buildSignoutButton(() {
          context.read<AuthBloc>().add(SignOutRequested());
        }),
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
        child: const Text("Sign out"),
      ),
    );
  }
}
