import '../../models/aluno_model.dart';
import 'database_helper.dart';

class AlunoLocalDs {
  final DatabaseHelper _db;

  AlunoLocalDs(this._db);

  DatabaseHelper get db => _db;

  Future<AlunoModel?> findByCredencial(String identificador) async {
    try {
      print('🔍 Buscando usuário: $identificador');
      final conn = await _db.connection;
      print('✅ Conectou no banco!');
      final result = await conn.execute(
        'SELECT * FROM alunos WHERE (matricula = :id OR email = :id) AND ativo = 1 LIMIT 1',
        {'id': identificador},
      );
      print('📦 Resultado: ${result.rows.length} linha(s)');
      if (result.rows.isEmpty) return null;
      return AlunoModel.fromMap(result.rows.first.assoc());
    } catch (e) {
      print('❌ Erro no banco: $e');
      return null;
    }
  }

  Future<AlunoModel?> findByMatricula(String matricula) async {
    try {
      final conn = await _db.connection;
      final result = await conn.execute(
        'SELECT * FROM alunos WHERE matricula = :m LIMIT 1',
        {'m': matricula},
      );
      if (result.rows.isEmpty) return null;
      return AlunoModel.fromMap(result.rows.first.assoc());
    } catch (e) {
      print('❌ Erro findByMatricula: $e');
      return null;
    }
  }

  Future<AlunoModel> insert(Map<String, dynamic> data) async {
    final conn = await _db.connection;
    await conn.execute(
      '''INSERT INTO alunos (nome, matricula, email, senha_hash, curso, periodo, municipio)
         VALUES (:nome, :mat, :email, :senha, :curso, :periodo, :municipio)''',
      {
        'nome':      data['nome'],
        'mat':       data['matricula'],
        'email':     data['email'],
        'senha':     data['senha'],
        'curso':     data['curso'],
        'periodo':   data['periodo'],
        'municipio': data['municipio'],
      },
    );
    final inserted = await findByMatricula(data['matricula']);
    return inserted!;
  }
}