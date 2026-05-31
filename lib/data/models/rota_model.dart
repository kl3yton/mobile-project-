import '../../domain/entities/rota.dart';

class HorarioModel extends Horario {
  const HorarioModel({
    required super.id,
    required super.partida,
    required super.turno,
  });

  factory HorarioModel.fromMap(Map<String, dynamic> map) {
    return HorarioModel(
      id:      int.parse(map['id'].toString()),
      partida: map['partida'].toString().substring(0, 5),
      turno:   map['turno'] as String,
    );
  }
}

class ParadaModel extends Parada {
  const ParadaModel({
    required super.id,
    required super.nome,
    super.lat,
    super.lng,
    required super.ordem,
  });

  factory ParadaModel.fromMap(Map<String, dynamic> map) {
    return ParadaModel(
      id:    int.parse(map['id'].toString()),
      nome:  map['nome'] as String,
      lat:   map['lat'] != null
               ? double.parse(map['lat'].toString())
               : null,
      lng:   map['lng'] != null
               ? double.parse(map['lng'].toString())
               : null,
      ordem: int.parse(map['ordem'].toString()),
    );
  }
}

class RotaModel extends Rota {
  const RotaModel({
    required super.id,
    required super.nome,
    required super.origem,
    required super.destino,
    super.ativa,
    super.horarios,
    super.paradas,
  });

  factory RotaModel.fromMap(
    Map<String, dynamic> map, {
    List<HorarioModel> horarios = const [],
    List<ParadaModel> paradas = const [],
  }) {
    return RotaModel(
      id:       int.parse(map['id'].toString()),
      nome:     map['nome'] as String,
      origem:   map['origem'] as String,
      destino:  map['destino'] as String,
      ativa:    map['ativa'].toString() == '1',
      horarios: horarios,
      paradas:  paradas,
    );
  }
}