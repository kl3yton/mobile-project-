import '../../domain/entities/aluno.dart';

class AlunoModel extends Aluno {
  const AlunoModel({
    required super.id,
    required super.nome,
    required super.matricula,
    required super.email,
    super.curso,
    super.periodo,
    super.municipio,
    super.ativo,
  });

  factory AlunoModel.fromMap(Map<String, dynamic> map) {
    return AlunoModel(
      id:        int.parse(map['id'].toString()),
      nome:      map['nome'] as String,
      matricula: map['matricula'] as String,
      email:     map['email'] as String,
      curso:     map['curso'] as String?,
      periodo:   map['periodo'] != null
                   ? int.parse(map['periodo'].toString())
                   : null,
      municipio: map['municipio'] as String?,
      ativo:     map['ativo'].toString() == '1',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome':      nome,
      'matricula': matricula,
      'email':     email,
      'curso':     curso,
      'periodo':   periodo,
      'municipio': municipio,
      'ativo':     ativo ? 1 : 0,
    };
  }
}