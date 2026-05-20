import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/documento.dart';
import '../repositories/documento_repository.dart';

class EnviarDocumentoUseCase implements UseCase<Documento, EnviarDocumentoParams> {
  final DocumentoRepository _repository;

  EnviarDocumentoUseCase(this._repository);

  @override
  Future<Either<Failure, Documento>> call(EnviarDocumentoParams params) {
    return _repository.enviarDocumento(
      alunoId: params.alunoId,
      tipo:    params.tipo,
      caminho: params.caminho,
    );
  }
}

class EnviarDocumentoParams extends Equatable {
  final int alunoId;
  final TipoDocumento tipo;
  final String caminho;

  const EnviarDocumentoParams({
    required this.alunoId,
    required this.tipo,
    required this.caminho,
  });

  @override
  List<Object?> get props => [alunoId, tipo, caminho];
}