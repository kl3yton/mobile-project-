import 'package:equatable/equatable.dart';

class Aluno extends Equatable {
  final int id;
  final String nome;
  final String matricula;
  final String email;
  final String? curso;
  final int? periodo;
  final String? municipio;
  final bool ativo;

  const Aluno({
    required this.id,
    required this.nome,
    required this.matricula,
    required this.email,
    this.curso,
    this.periodo,
    this.municipio,
    this.ativo = true,
  });

  @override
  List<Object?> get props =>
      [id, nome, matricula, email, curso, periodo, municipio, ativo];
}