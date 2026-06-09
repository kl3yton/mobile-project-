import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/passe.dart';
import '../../domain/repositories/passe_repository.dart';
import '../datasources/local/passe_local_ds.dart';

class PasseRepositoryImpl implements PasseRepository {
  final PasseLocalDs _ds;

  PasseRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, Passe>> getPassePorAluno(int alunoId) async {
    try {
      var passe = await _ds.getPasseAtivo(alunoId);
      passe ??= await _ds.criarPasse(alunoId);
      return Right(passe);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar passe: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> validarQRCode(String qrToken) async {
    try {
      final valido = await _ds.validarToken(qrToken);
      return Right(valido);
    } catch (e) {
      return Left(QRFailure('Erro ao validar QR Code: $e'));
    }
  }

  @override
  Future<Either<Failure, Passe>> criarPasse(int alunoId) async {
    try {
      final passe = await _ds.criarPasse(alunoId);
      return Right(passe);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao criar passe: $e'));
    }
  }
}