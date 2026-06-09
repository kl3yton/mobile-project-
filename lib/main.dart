import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/rotas/rotas_bloc.dart';
import 'presentation/blocs/passe/passe_bloc.dart';
import 'router.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const UnipasApp());
}

class UnipasApp extends StatelessWidget {
  const UnipasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const SessaoVerificada()),
        ),
        BlocProvider<RotasBloc>(
          create: (_) => sl<RotasBloc>(),
        ),
        BlocProvider<PasseBloc>(
          create: (_) => sl<PasseBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title:                      'Unipas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3:           true,
          colorSchemeSeed:        AppColors.brand,
          scaffoldBackgroundColor: AppColors.gray50,
          fontFamily:             'Sora',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.brand,
            foregroundColor: AppColors.white,
            elevation:       0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.white,
              minimumSize:     const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.brand,
              minimumSize:     const Size(double.infinity, 48),
              side: const BorderSide(color: AppColors.brand, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled:    true,
            fillColor: AppColors.gray50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: AppColors.gray200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: AppColors.gray200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.brand, width: 1.5),
            ),
          ),
        ),
        routerConfig: buildRouter(),
      ),
    );
  }
}