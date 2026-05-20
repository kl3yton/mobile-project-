import 'package:equatable/equatable.dart';

class Parada extends Equatable {
  final int id;
  final String nome;
  final double? lat;
  final double? lng;
  final int ordem;

  const Parada({
    required this.id,
    required this.nome,
    this.lat,
    this.lng,
    required this.ordem,
  });

  @override
  List<Object?> get props => [id, nome, lat, lng, ordem];
}

class Horario extends Equatable {
  final int id;
  final String partida;
  final String turno;

  const Horario({
    required this.id,
    required this.partida,
    required this.turno,
  });

  @override
  List<Object?> get props => [id, partida, turno];
}

class Rota extends Equatable {
  final int id;
  final String nome;
  final String origem;
  final String destino;
  final bool ativa;
  final List<Horario> horarios;
  final List<Parada> paradas;

  const Rota({
    required this.id,
    required this.nome,
    required this.origem,
    required this.destino,
    this.ativa = true,
    this.horarios = const [],
    this.paradas = const [],
  });

  @override
  List<Object?> get props => [id, nome, origem, destino, ativa];
}