import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/rotas/rotas_bloc.dart';

class RotasScreen extends StatelessWidget {
  const RotasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return const SizedBox();
    final aluno = authState.aluno;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Rotas'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<RotasBloc, RotasState>(
        builder: (context, state) {
          if (state is RotasInitial) {
            context.read<RotasBloc>().add(LoadRotas(aluno.id));
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RotasLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RotasError) {
            return Center(child: Text(state.message));
          }
          if (state is RotasLoaded) {
            if (state.rotas.isEmpty) {
              return const Center(
                child: Text('Nenhuma rota disponível'),
              );
            }
            return ListView.builder(
              padding:     const EdgeInsets.all(16),
              itemCount:   state.rotas.length,
              itemBuilder: (_, i) {
                final rota = state.rotas[i];
                return GestureDetector(
                  onTap: () => context.go('/rotas/${rota.id}'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:        AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width:  42, height: 42,
                          decoration: BoxDecoration(
                            color:        AppColors.brandLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.directions_bus,
                            color: AppColors.brand,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rota.nome,
                                style: const TextStyle(
                                  fontSize:   13,
                                  fontWeight: FontWeight.w600,
                                  color:      AppColors.gray800,
                                ),
                              ),
                              Text(
                                '${rota.horarios.length} horários · ${rota.origem} → ${rota.destino}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color:    AppColors.gray400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:        AppColors.successBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '● Em operação',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color:    AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.gray400,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}