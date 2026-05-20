import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/aluno.dart';
import '../repositories/auth_repository.dart';

class CadastrarAlunoUseCase implements UseCase<Aluno, CadastrarParams> {
  final AuthRepository _repository;

  CadastrarAlunoUseCase(this._repository);

  @override
  Future<Either<Failure, Aluno>> call(CadastrarParams params) {
    return _repository.cadastrar(
      nome:      params.nome,
      matricula: params.matricula,
      email:     params.email,
      senha:     params.senha,
      curso:     params.curso,
      periodo:   params.periodo,
      municipio: params.municipio,
    );
  }
}

class CadastrarParams extends Equatable {
  final String nome;
  final String matricula;
  final String email;
  final String senha;
  final String? curso;
  final int? periodo;
  final String? municipio;

  const CadastrarParams({
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha,
    this.curso,
    this.periodo,
    this.municipio,
  });

  @override
  List<Object?> get props =>
      [nome, matricula, email, senha, curso, periodo, municipio];
}