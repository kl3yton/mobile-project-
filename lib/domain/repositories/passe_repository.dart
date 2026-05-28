import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/passe.dart';

abstract class PasseRepository {
  Future<Either<Failure, Passe>> getPassePorAluno(int alunoId);
  Future<Either<Failure, bool>> validarQRCode(String qrToken);
  Future<Either<Failure, Passe>> criarPasse(int alunoId);
}