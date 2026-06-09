import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/rotas/rotas_bloc.dart';

class RotaDetalheScreen extends StatelessWidget {
  final int rotaId;
  const RotaDetalheScreen({super.key, required this.rotaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Rota')),
      body: BlocBuilder<RotasBloc, RotasState>(
        builder: (context, state) {
          if (state is! RotasLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final rotas = state.rotas.where((r) => r.id == rotaId).toList();
          if (rotas.isEmpty) {
            return const Center(child: Text('Rota não encontrada'));
          }
          final rota = rotas.first;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:        AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border:       Border.all(color: AppColors.gray200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rota.nome,
                        style: const TextStyle(
                          fontSize:   16,
                          fontWeight: FontWeight.w700,
                          color:      AppColors.gray800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${rota.origem} → ${rota.destino}',
                        style: const TextStyle(
                          fontSize: 13,
                          color:    AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Paradas',
                  style: TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 8),
                ...rota.paradas.asMap().entries.map((e) {
                  final isLast = e.key == rota.paradas.length - 1;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width:  12, height: 12,
                            decoration: BoxDecoration(
                              color:  e.key == 0
                                  ? AppColors.brand
                                  : AppColors.gray200,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: e.key == 0
                                    ? AppColors.brand
                                    : AppColors.gray400,
                              ),
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2, height: 32,
                              color: AppColors.gray200,
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          e.value.nome,
                          style: const TextStyle(
                            fontSize:   13,
                            fontWeight: FontWeight.w500,
                            color:      AppColors.gray800,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 16),
                const Text(
                  'Horários',
                  style: TextStyle(
                    fontSize:   13,
                    fontWeight: FontWeight.w600,
                    color:      AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 8),
                ...rota.horarios.map((h) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:        AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:       Border.all(color: AppColors.gray200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        h.partida,
                        style: const TextStyle(
                          fontSize:   14,
                          fontWeight: FontWeight.w700,
                          color:      AppColors.brand,
                        ),
                      ),
                      Text(
                        h.turno,
                        style: const TextStyle(
                          fontSize: 12,
                          color:    AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}