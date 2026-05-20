import 'package:equatable/equatable.dart';

enum TipoDocumento { selfie, comprovanteResidencia, comprovanteMatricula }

enum StatusDocumento { pendente, aprovado, rejeitado }

class Documento extends Equatable {
  final int id;
  final int alunoId;
  final TipoDocumento tipo;
  final String caminho;
  final StatusDocumento status;
  final String? observacao;
  final DateTime enviadoEm;

  const Documento({
    required this.id,
    required this.alunoId,
    required this.tipo,
    required this.caminho,
    required this.status,
    this.observacao,
    required this.enviadoEm,
  });

  @override
  List<Object?> get props =>
      [id, alunoId, tipo, caminho, status, observacao, enviadoEm];
}