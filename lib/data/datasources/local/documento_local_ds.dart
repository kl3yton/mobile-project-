import '../../models/documento_model.dart';
import 'database_helper.dart';

class DocumentoLocalDs {
  final DatabaseHelper _db;

  DocumentoLocalDs(this._db);

  Future<List<DocumentoModel>> getDocumentosPorAluno(int alunoId) async {
    final conn   = await _db.connection;
    final result = await conn.execute(
      'SELECT * FROM documentos WHERE aluno_id = :id ORDER BY enviado_em DESC',
      {'id': alunoId},
    );
    return result.rows.map((r) => DocumentoModel.fromMap(r.assoc())).toList();
  }

  Future<DocumentoModel> inserir({
    required int alunoId,
    required String tipo,
    required String caminho,
  }) async {
    final conn = await _db.connection;
    await conn.execute(
      '''INSERT INTO documentos (aluno_id, tipo, caminho, status)
         VALUES (:aid, :tipo, :caminho, "pendente")''',
      {'aid': alunoId, 'tipo': tipo, 'caminho': caminho},
    );
    final result = await conn.execute(
      'SELECT * FROM documentos WHERE aluno_id = :id ORDER BY enviado_em DESC LIMIT 1',
      {'id': alunoId},
    );
    return DocumentoModel.fromMap(result.rows.first.assoc());
  }
}