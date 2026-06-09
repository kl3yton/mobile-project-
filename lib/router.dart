import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/cadastro_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/rotas/rotas_screen.dart';
import 'presentation/screens/rotas/rota_detalhe_screen.dart';
import 'presentation/screens/passe/passe_screen.dart';
import 'presentation/screens/documentos/documentos_screen.dart';
import 'presentation/screens/perfil/perfil_screen.dart';
import 'service_locator.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final authState = sl<AuthBloc>().state;
      final isAuth    = authState is AuthAuthenticated;
      final isPublic  = ['/splash', '/login', '/cadastro', '/documentos']
          .contains(state.matchedLocation);

      if (!isAuth && !isPublic) return '/login';
      if (isAuth  &&  isPublic) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path:    '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path:    '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path:    '/cadastro',
        builder: (_, __) => const CadastroScreen(),
      ),
      GoRoute(
        path:    '/documentos',
        builder: (_, __) => const DocumentosScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path:    '/home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path:    '/rotas',
            builder: (_, __) => const RotasScreen(),
          ),
          GoRoute(
            path:    '/rotas/:id',
            builder: (_, state) => RotaDetalheScreen(
              rotaId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path:    '/passe',
            builder: (_, __) => const PasseScreen(),
          ),
          GoRoute(
            path:    '/perfil',
            builder: (_, __) => const PerfilScreen(),
          ),
        ],
      ),
    ],
  );
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _index(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith('/rotas'))  return 1;
    if (loc.startsWith('/passe'))  return 2;
    if (loc.startsWith('/perfil')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:        _index(context),
        selectedItemColor:   const Color(0xFF0056D2),
        unselectedItemColor: const Color(0xFF9399AB),
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          switch (i) {
            case 0: context.go('/home');   break;
            case 1: context.go('/rotas');  break;
            case 2: context.go('/passe');  break;
            case 3: context.go('/perfil'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon:  Icon(Icons.home_outlined),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.map_outlined),
            label: 'Rotas',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.qr_code_rounded),
            label: 'Passe',
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}