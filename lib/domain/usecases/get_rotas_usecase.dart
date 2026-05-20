import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/rota.dart';
import '../repositories/rota_repository.dart';

class GetRotasUseCase implements UseCase<List<Rota>, int> {
  final RotaRepository _repository;

  GetRotasUseCase(this._repository);

  @override
  Future<Either<Failure, List<Rota>>> call(int alunoId) {
    return _repository.getRotasPorAluno(alunoId);
  }
}

class GetProximaViagemUseCase implements UseCase<Horario, int> {
  final RotaRepository _repository;

  GetProximaViagemUseCase(this._repository);

  @override
  Future<Either<Failure, Horario>> call(int alunoId) {
    return _repository.getProximaViagem(alunoId);
  }
}