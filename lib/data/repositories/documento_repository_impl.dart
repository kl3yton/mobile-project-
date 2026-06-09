import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/documento.dart';
import '../../domain/repositories/documento_repository.dart';
import '../datasources/local/documento_local_ds.dart';

class DocumentoRepositoryImpl implements DocumentoRepository {
  final DocumentoLocalDs _ds;

  DocumentoRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, List<Documento>>> getDocumentosPorAluno(
      int alunoId) async {
    try {
      final docs = await _ds.getDocumentosPorAluno(alunoId);
      return Right(docs);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao buscar documentos: $e'));
    }
  }

  @override
  Future<Either<Failure, Documento>> enviarDocumento({
    required int alunoId,
    required TipoDocumento tipo,
    required String caminho,
  }) async {
    try {
      final tipoStr = tipo == TipoDocumento.selfie
          ? 'selfie'
          : tipo == TipoDocumento.comprovanteResidencia
              ? 'comprovante_residencia'
              : 'comprovante_matricula';

      final doc = await _ds.inserir(
        alunoId: alunoId,
        tipo:    tipoStr,
        caminho: caminho,
      );
      return Right(doc);
    } catch (e) {
      return Left(UploadFailure('Erro ao enviar documento: $e'));
    }
  }
}