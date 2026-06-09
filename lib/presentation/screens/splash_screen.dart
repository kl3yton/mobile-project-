import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated)   context.go('/home');
        if (state is AuthUnauthenticated) context.go('/login');
      },
      child: Scaffold(
        backgroundColor: AppColors.brand,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_bus_rounded,
                  size: 64, color: Colors.white),
              const SizedBox(height: 16),
              const Text(
                'UNIPAS',
                style: TextStyle(
                  color:       Colors.white,
                  fontSize:    52,
                  fontWeight:  FontWeight.w800,
                  letterSpacing: -3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'TRANSPORTE UNIVERSITÁRIO',
                style: TextStyle(
                  color:       Colors.white.withOpacity(0.7),
                  fontSize:    12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}