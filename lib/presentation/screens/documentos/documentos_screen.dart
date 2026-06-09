import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class DocumentosScreen extends StatelessWidget {
  const DocumentosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documentos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:        AppColors.brandLight,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: AppColors.brand, width: 3),
                ),
              ),
              child: const Text(
                '📋 Envie os documentos abaixo para validar sua conta.',
                style: TextStyle(fontSize: 12, color: AppColors.brand),
              ),
            ),
            const SizedBox(height: 16),
            _DocItem(
              icon:   '🤳',
              nome:   'Selfie de Identificação',
              descr:  'Foto do rosto com documento',
              status: 'Pendente',
              ok:     false,
            ),
            _DocItem(
              icon:   '🏠',
              nome:   'Comprovante de Residência',
              descr:  'Máx. 90 dias de emissão',
              status: 'Enviado',
              ok:     true,
            ),
            _DocItem(
              icon:   '🎓',
              nome:   'Comprovante de Matrícula',
              descr:  'Gerado pelo portal acadêmico',
              status: 'Aprovado',
              ok:     true,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon:  const Icon(Icons.camera_alt_outlined),
              label: const Text('Enviar Selfie'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Continuar para o App →'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocItem extends StatelessWidget {
  final String icon;
  final String nome;
  final String descr;
  final String status;
  final bool ok;

  const _DocItem({
    required this.icon,
    required this.nome,
    required this.descr,
    required this.status,
    required this.ok,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:        AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width:  36, height: 36,
            decoration: BoxDecoration(
              color:        AppColors.brandLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nome,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                Text(descr,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.gray400)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: ok ? AppColors.successBg : AppColors.warningBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize:   10,
                fontWeight: FontWeight.w600,
                color:      ok ? AppColors.success : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}