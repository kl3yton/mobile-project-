import 'package:uuid/uuid.dart';
import '../../models/passe_model.dart';
import 'database_helper.dart';

class PasseLocalDs {
  final DatabaseHelper _db;

  PasseLocalDs(this._db);

  Future<PasseModel?> getPasseAtivo(int alunoId) async {
    final conn   = await _db.connection;
    final result = await conn.execute(
      'SELECT * FROM passes WHERE aluno_id = :id AND status = "ativo" LIMIT 1',
      {'id': alunoId},
    );
    if (result.rows.isEmpty) return null;
    return PasseModel.fromMap(result.rows.first.assoc());
  }

  Future<PasseModel> criarPasse(int alunoId) async {
    final conn  = await _db.connection;
    final token = const Uuid().v4();
    final hoje  = DateTime.now();
    final fim   = DateTime(hoje.year, 12, 31);

    await conn.execute(
      '''INSERT INTO passes (aluno_id, qr_token, validade_ini, validade_fim, status)
         VALUES (:aid, :token, :ini, :fim, "ativo")''',
      {
        'aid':   alunoId,
        'token': token,
        'ini':   hoje.toIso8601String().substring(0, 10),
        'fim':   fim.toIso8601String().substring(0, 10),
      },
    );

    return (await getPasseAtivo(alunoId))!;
  }

  Future<bool> validarToken(String qrToken) async {
    final conn   = await _db.connection;
    final result = await conn.execute(
      '''SELECT id FROM passes
         WHERE qr_token = :token
           AND status = "ativo"
           AND validade_ini <= CURDATE()
           AND validade_fim >= CURDATE()
         LIMIT 1''',
      {'token': qrToken},
    );
    return result.rows.isNotEmpty;
  }

  Future<void> registrarEmbarque(int passeId, int rotaId) async {
    final conn = await _db.connection;
    await conn.execute(
      'INSERT INTO embarques (passe_id, rota_id) VALUES (:pid, :rid)',
      {'pid': passeId, 'rid': rotaId},
    );
  }
}