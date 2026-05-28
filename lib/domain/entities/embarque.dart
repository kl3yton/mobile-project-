import 'package:equatable/equatable.dart';

class Embarque extends Equatable {
  final int id;
  final int passeId;
  final int rotaId;
  final DateTime embarcadoEm;

  const Embarque({
    required this.id,
    required this.passeId,
    required this.rotaId,
    required this.embarcadoEm,
  });

  @override
  List<Object?> get props => [id, passeId, rotaId, embarcadoEm];
}