import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/passe.dart';
import '../repositories/passe_repository.dart';

class GetPasseUseCase implements UseCase<Passe, int> {
  final PasseRepository _repository;

  GetPasseUseCase(this._repository);

  @override
  Future<Either<Failure, Passe>> call(int alunoId) {
    return _repository.getPassePorAluno(alunoId);
  }
}

class ValidarQRUseCase implements UseCase<bool, String> {
  final PasseRepository _repository;

  ValidarQRUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(String qrToken) {
    return _repository.validarQRCode(qrToken);
  }
}