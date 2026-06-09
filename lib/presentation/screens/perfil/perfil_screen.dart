import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return const SizedBox();
    final aluno = authState.aluno;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:        AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border:       Border.all(color: AppColors.gray200),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius:          28,
                  backgroundColor: AppColors.brand,
                  child: Text(
                    aluno.nome[0],
                    style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aluno.nome,
                        style: const TextStyle(
                          fontSize:   15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        aluno.curso ?? 'Estudante',
                        style: const TextStyle(
                          fontSize: 12,
                          color:    AppColors.gray400,
                        ),
                      ),
                      Text(
                        'Mat: ${aluno.matricula}',
                        style: const TextStyle(
                          fontSize: 12,
                          color:    AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Dados Acadêmicos',
            style: TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.w600,
              color:      AppColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          _InfoCard(items: {
            'Matrícula':    aluno.matricula,
            'E-mail':       aluno.email,
            'Curso':        aluno.curso    ?? '—',
            'Período':      aluno.periodo  != null ? '${aluno.periodo}º' : '—',
            'Município':    aluno.municipio ?? '—',
          }),
          const SizedBox(height: 16),
          const Text(
            'Configurações',
            style: TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.w600,
              color:      AppColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          _MenuItem(
            icon:  Icons.notifications_outlined,
            label: 'Notificações',
            onTap: () {},
          ),
          _MenuItem(
            icon:  Icons.description_outlined,
            label: 'Meus Documentos',
            onTap: () => context.go('/documentos'),
          ),
          _MenuItem(
            icon:  Icons.lock_outline,
            label: 'Privacidade e Segurança',
            onTap: () {},
          ),
          _MenuItem(
            icon:    Icons.logout,
            label:   'Sair da conta',
            isRed:   true,
            onTap: () {
              context.read<AuthBloc>().add(const LogoutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Map<String, String> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: items.entries.map((e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e.key,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.gray400)),
              Text(e.value,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:      AppColors.gray800)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String   label;
  final bool     isRed;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:        AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isRed ? Colors.red : AppColors.gray600,
                size:  20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize:   13,
                  fontWeight: FontWeight.w500,
                  color:      isRed ? Colors.red : AppColors.gray800,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: isRed ? Colors.red : AppColors.gray400),
          ],
        ),
      ),
    );
  }
} 