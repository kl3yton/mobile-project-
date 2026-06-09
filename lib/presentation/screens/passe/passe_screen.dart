import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/passe/passe_bloc.dart';

class PasseScreen extends StatelessWidget {
  const PasseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return const SizedBox();
    final aluno = authState.aluno;

    return Scaffold(
      appBar: AppBar(
        title:    const Text('Passe Digital'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<PasseBloc, PasseState>(
        builder: (context, state) {
          if (state is PasseInitial) {
            context.read<PasseBloc>().add(LoadPasse(aluno.id));
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PasseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PasseError) {
            return Center(child: Text(state.message));
          }
          if (state is PasseLoaded) {
            final passe = state.passe;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width:   double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:        AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border:       Border.all(color: AppColors.gray200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.brand,
                          child: Text(
                            aluno.nome[0],
                            style: const TextStyle(
                              color:      Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              aluno.nome,
                              style: const TextStyle(
                                fontSize:   14,
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: passe.isValido
                            ? AppColors.successBg
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size:  8,
                            color: passe.isValido
                                ? AppColors.success
                                : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            passe.isValido
                                ? 'QR Code Válido'
                                : 'QR Code Inválido',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: passe.isValido
                                  ? AppColors.success
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    QrImageView(
                      data:    passe.qrToken,
                      version: QrVersions.auto,
                      size:    200,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color:    AppColors.brand,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color:           AppColors.brand,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      passe.qrToken.substring(0, 20) + '...',
                      style: const TextStyle(
                        fontSize:   11,
                        color:      AppColors.gray400,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Divider(height: 24),
                    Text(
                      'Válido até ${passe.validadeFim.day.toString().padLeft(2, '0')}/'
                      '${passe.validadeFim.month.toString().padLeft(2, '0')}/'
                      '${passe.validadeFim.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color:    AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}