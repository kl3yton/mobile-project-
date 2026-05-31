import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/rota.dart';

abstract class RotaRepository {
  Future<Either<Failure, List<Rota>>> getRotasPorAluno(int alunoId);
  Future<Either<Failure, Rota>> getRotaById(int rotaId);
  Future<Either<Failure, Horario>> getProximaViagem(int alunoId);
}