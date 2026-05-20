import '../../domain/entities/passe.dart';

class PasseModel extends Passe {
  const PasseModel({
    required super.id,
    required super.alunoId,
    required super.qrToken,
    required super.validadeIni,
    required super.validadeFim,
    required super.status,
  });

  factory PasseModel.fromMap(Map<String, dynamic> map) {
    return PasseModel(
      id:          int.parse(map['id'].toString()),
      alunoId:     int.parse(map['aluno_id'].toString()),
      qrToken:     map['qr_token'] as String,
      validadeIni: DateTime.parse(map['validade_ini'].toString()),
      validadeFim: DateTime.parse(map['validade_fim'].toString()),
      status:      _parseStatus(map['status'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'aluno_id':    alunoId,
      'qr_token':    qrToken,
      'validade_ini': validadeIni.toIso8601String().substring(0, 10),
      'validade_fim': validadeFim.toIso8601String().substring(0, 10),
      'status':      status.name,
    };
  }

  static StatusPasse _parseStatus(String s) {
    switch (s) {
      case 'suspenso': return StatusPasse.suspenso;
      case 'expirado': return StatusPasse.expirado;
      default:         return StatusPasse.ativo;
    }
  }
}