import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/rotas/rotas_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    if (state is! AuthAuthenticated) return const SizedBox();
    final aluno = state.aluno;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${aluno.nome.split(' ').first} 👋',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const Text(
              'Próxima Viagem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () => context.go('/perfil'),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              child: Text(
                aluno.nome[0],
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<RotasBloc, RotasState>(
        builder: (context, rotasState) {
          if (rotasState is RotasInitial) {
            context.read<RotasBloc>().add(LoadRotas(aluno.id));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TripCard(
                  horario: rotasState is RotasLoaded
                      ? rotasState.proximaViagem?.partida ?? '--:--'
                      : '--:--',
                  rota: rotasState is RotasLoaded &&
                          rotasState.rotas.isNotEmpty
                      ? rotasState.rotas.first.nome
                      : 'Carregando...',
                ),
                const SizedBox(height: 16),
                _StatsRow(
                  viagens: 12,
                  rotas: rotasState is RotasLoaded
                      ? rotasState.rotas.length
                      : 0,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go('/passe'),
                  icon:  const Icon(Icons.qr_code_rounded),
                  label: const Text('Abrir Meu Passe Digital'),
                ),
                const SizedBox(height: 16),
                if (rotasState is RotasLoaded &&
                    rotasState.rotas.isNotEmpty)
                  _HorariosCard(rotas: rotasState.rotas),
                if (rotasState is RotasLoading)
                  const Center(child: CircularProgressIndicator()),
                if (rotasState is RotasError)
                  _ErroCard(message: rotasState.message),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final String horario;
  final String rota;
  const _TripCard({required this.horario, required this.rota});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0056D2), Color(0xFF4A86E8)],
          begin:  Alignment.topLeft,
          end:    Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Partida em',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            horario,
            style: const TextStyle(
              color:        Colors.white,
              fontSize:     48,
              fontWeight:   FontWeight.w800,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '🚌 $rota',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _badge('📍 Ponto Principal'),
              _badge('⏱ Em breve'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:        Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      );
}

class _StatsRow extends StatelessWidget {
  final int viagens;
  final int rotas;
  const _StatsRow({required this.viagens, required this.rotas});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(valor: '$viagens', label: 'Viagens este mês'),
        const SizedBox(width: 8),
        _StatBox(valor: '$rotas',   label: 'Rotas ativas'),
        const SizedBox(width: 8),
        const _StatBox(valor: '✓', label: 'Passe válido'),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String valor;
  final String label;
  const _StatBox({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:        AppColors.brandLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(
                fontSize:   22,
                fontWeight: FontWeight.w700,
                color:      AppColors.brand,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color:    AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HorariosCard extends StatelessWidget {
  final List<dynamic> rotas;
  const _HorariosCard({required this.rotas});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Próximos Horários',
            style: TextStyle(
              fontSize:   13,
              fontWeight: FontWeight.w600,
              color:      AppColors.gray800,
            ),
          ),
          const Divider(height: 20),
          ...rotas.take(3).expand((rota) =>
            rota.horarios.take(2).map<Widget>((h) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${h.partida} — ${rota.nome}',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.gray800),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color:        AppColors.brandLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      h.turno,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.brand),
                    ),
                  ),
                ],
              ),
            )).toList()
          ),
        ],
      ),
    );
  }
}

class _ErroCard extends StatelessWidget {
  final String message;
  const _ErroCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
        border:       Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}