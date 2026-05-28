import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/aluno.dart';

abstract class AuthRepository {
  Future<Either<Failure, Aluno>> login({
    required String identificador,
    required String senha,
  });

  Future<Either<Failure, Aluno>> cadastrar({
    required String nome,
    required String matricula,
    required String email,
    required String senha,
    String? curso,
    int? periodo,
    String? municipio,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, Aluno?>> getSessaoAtiva();
}