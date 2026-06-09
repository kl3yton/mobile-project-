import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/rota.dart';
import '../../domain/repositories/rota_repository.dart';
import '../datasources/local/rota_local_ds.dart';

class RotaRepositoryImpl implements RotaRepository {
  final RotaLocalDs _ds;

  RotaRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, List<Rota>>> getRotasPorAluno(int alunoId) async {
    try {
      final rotas = await _ds.getRotasPorAluno(alunoId);
      return Right(rotas);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar rotas: $e'));
    }
  }

  @override
  Future<Either<Failure, Rota>> getRotaById(int rotaId) async {
    try {
      final rota = await _ds.getRotaById(rotaId);
      if (rota == null) {
        return Left(const NotFoundFailure('Rota não encontrada'));
      }
      return Right(rota);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar rota: $e'));
    }
  }

  @override
  Future<Either<Failure, Horario>> getProximaViagem(int alunoId) async {
    try {
      final horario = await _ds.getProximaViagem(alunoId);
      if (horario == null) {
        return Left(const NotFoundFailure('Nenhuma viagem disponível hoje'));
      }
      return Right(horario);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar próxima viagem: $e'));
    }
  }
}