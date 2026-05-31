import '../../models/rota_model.dart';
import 'database_helper.dart';

class RotaLocalDs {
  final DatabaseHelper _db;

  RotaLocalDs(this._db);

  Future<List<RotaModel>> getRotasPorAluno(int alunoId) async {
    final conn = await _db.connection;
    final result = await conn.execute(
      '''SELECT r.* FROM rotas r
         INNER JOIN aluno_rotas ar ON ar.rota_id = r.id
         WHERE ar.aluno_id = :id AND r.ativa = 1
         ORDER BY r.nome''',
      {'id': alunoId},
    );

    final rotas = <RotaModel>[];
    for (final row in result.rows) {
      final map    = row.assoc();
      final rotaId = int.parse(map['id'].toString());

      final hResult = await conn.execute(
        'SELECT * FROM horarios WHERE rota_id = :rid ORDER BY partida',
        {'rid': rotaId},
      );
      final pResult = await conn.execute(
        'SELECT * FROM paradas WHERE rota_id = :rid ORDER BY ordem',
        {'rid': rotaId},
      );

      rotas.add(RotaModel.fromMap(
        map,
        horarios: hResult.rows.map((r) => HorarioModel.fromMap(r.assoc())).toList(),
        paradas:  pResult.rows.map((r) => ParadaModel.fromMap(r.assoc())).toList(),
      ));
    }
    return rotas;
  }

  Future<RotaModel?> getRotaById(int rotaId) async {
    final conn   = await _db.connection;
    final result = await conn.execute(
      'SELECT * FROM rotas WHERE id = :id LIMIT 1',
      {'id': rotaId},
    );
    if (result.rows.isEmpty) return null;

    final hResult = await conn.execute(
      'SELECT * FROM horarios WHERE rota_id = :rid ORDER BY partida',
      {'rid': rotaId},
    );
    final pResult = await conn.execute(
      'SELECT * FROM paradas WHERE rota_id = :rid ORDER BY ordem',
      {'rid': rotaId},
    );

    return RotaModel.fromMap(
      result.rows.first.assoc(),
      horarios: hResult.rows.map((r) => HorarioModel.fromMap(r.assoc())).toList(),
      paradas:  pResult.rows.map((r) => ParadaModel.fromMap(r.assoc())).toList(),
    );
  }

  Future<HorarioModel?> getProximaViagem(int alunoId) async {
    final conn  = await _db.connection;
    final agora = DateTime.now();
    final hora  =
        '${agora.hour.toString().padLeft(2, '0')}:${agora.minute.toString().padLeft(2, '0')}:00';

    final result = await conn.execute(
      '''SELECT h.* FROM horarios h
         INNER JOIN rotas r ON r.id = h.rota_id
         INNER JOIN aluno_rotas ar ON ar.rota_id = r.id
         WHERE ar.aluno_id = :id AND h.partida > :hora AND r.ativa = 1
         ORDER BY h.partida ASC LIMIT 1''',
      {'id': alunoId, 'hora': hora},
    );
    if (result.rows.isEmpty) return null;
    return HorarioModel.fromMap(result.rows.first.assoc());
  }
}