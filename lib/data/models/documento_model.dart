import '../../domain/entities/documento.dart';

class DocumentoModel extends Documento {
  const DocumentoModel({
    required super.id,
    required super.alunoId,
    required super.tipo,
    required super.caminho,
    required super.status,
    super.observacao,
    required super.enviadoEm,
  });

  factory DocumentoModel.fromMap(Map<String, dynamic> map) {
    return DocumentoModel(
      id:         int.parse(map['id'].toString()),
      alunoId:    int.parse(map['aluno_id'].toString()),
      tipo:       _parseTipo(map['tipo'] as String),
      caminho:    map['caminho'] as String,
      status:     _parseStatus(map['status'] as String),
      observacao: map['observacao'] as String?,
      enviadoEm:  DateTime.parse(map['enviado_em'].toString()),
    );
  }

  static TipoDocumento _parseTipo(String t) {
    switch (t) {
      case 'selfie':                 return TipoDocumento.selfie;
      case 'comprovante_residencia': return TipoDocumento.comprovanteResidencia;
      default:                       return TipoDocumento.comprovanteMatricula;
    }
  }

  static StatusDocumento _parseStatus(String s) {
    switch (s) {
      case 'aprovado':  return StatusDocumento.aprovado;
      case 'rejeitado': return StatusDocumento.rejeitado;
      default:          return StatusDocumento.pendente;
    }
  }
}