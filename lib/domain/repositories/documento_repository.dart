import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/documento.dart';

abstract class DocumentoRepository {
  Future<Either<Failure, List<Documento>>> getDocumentosPorAluno(int alunoId);

  Future<Either<Failure, Documento>> enviarDocumento({
    required int alunoId,
    required TipoDocumento tipo,
    required String caminho,
  });
}