import 'package:equatable/equatable.dart';

enum StatusPasse { ativo, suspenso, expirado }

class Passe extends Equatable {
  final int id;
  final int alunoId;
  final String qrToken;
  final DateTime validadeIni;
  final DateTime validadeFim;
  final StatusPasse status;

  const Passe({
    required this.id,
    required this.alunoId,
    required this.qrToken,
    required this.validadeIni,
    required this.validadeFim,
    required this.status,
  });

  bool get isValido =>
      status == StatusPasse.ativo &&
      DateTime.now().isBefore(validadeFim) &&
      DateTime.now().isAfter(validadeIni);

  @override
  List<Object?> get props =>
      [id, alunoId, qrToken, validadeIni, validadeFim, status];
}