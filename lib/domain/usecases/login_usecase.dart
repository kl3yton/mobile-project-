import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/aluno.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<Aluno, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Aluno>> call(LoginParams params) {
    return _repository.login(
      identificador: params.identificador,
      senha: params.senha,
    );
  }
}

class LoginParams extends Equatable {
  final String identificador;
  final String senha;

  const LoginParams({
    required this.identificador,
    required this.senha,
  });

  @override
  List<Object?> get props => [identificador, senha];
}