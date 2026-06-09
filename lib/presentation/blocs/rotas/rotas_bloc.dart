import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/rota.dart';
import '../../../domain/usecases/get_rotas_usecase.dart';

// ── Events ──────────────────────────────────────────────────
abstract class RotasEvent extends Equatable {
  const RotasEvent();
  @override
  List<Object?> get props => [];
}

class LoadRotas extends RotasEvent {
  final int alunoId;
  const LoadRotas(this.alunoId);
  @override
  List<Object?> get props => [alunoId];
}

// ── States ──────────────────────────────────────────────────
abstract class RotasState extends Equatable {
  const RotasState();
  @override
  List<Object?> get props => [];
}

class RotasInitial extends RotasState { const RotasInitial(); }
class RotasLoading extends RotasState { const RotasLoading(); }

class RotasLoaded extends RotasState {
  final List<Rota> rotas;
  final Horario?   proximaViagem;

  const RotasLoaded({required this.rotas, this.proximaViagem});

  @override
  List<Object?> get props => [rotas, proximaViagem];
}

class RotasError extends RotasState {
  final String message;
  const RotasError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── BLoC ────────────────────────────────────────────────────
class RotasBloc extends Bloc<RotasEvent, RotasState> {
  final GetRotasUseCase         _getRotas;
  final GetProximaViagemUseCase _getProxima;

  RotasBloc({
    required GetRotasUseCase getRotas,
    required GetProximaViagemUseCase getProximaViagem,
  })  : _getRotas   = getRotas,
        _getProxima = getProximaViagem,
        super(const RotasInitial()) {
    on<LoadRotas>(_onLoad);
  }

  Future<void> _onLoad(LoadRotas event, Emitter<RotasState> emit) async {
    emit(const RotasLoading());
    final rotasResult   = await _getRotas(event.alunoId);
    final proximaResult = await _getProxima(event.alunoId);

    rotasResult.fold(
      (f) => emit(RotasError(f.message)),
      (rotas) {
        final proxima = proximaResult.fold((_) => null, (h) => h);
        emit(RotasLoaded(rotas: rotas, proximaViagem: proxima));
      },
    );
  }
}