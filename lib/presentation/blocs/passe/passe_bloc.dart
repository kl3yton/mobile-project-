import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/passe.dart';
import '../../../domain/usecases/get_passe_usecase.dart';

// ── Events ──────────────────────────────────────────────────
abstract class PasseEvent extends Equatable {
  const PasseEvent();
  @override
  List<Object?> get props => [];
}

class LoadPasse extends PasseEvent {
  final int alunoId;
  const LoadPasse(this.alunoId);
  @override
  List<Object?> get props => [alunoId];
}

class ValidarQR extends PasseEvent {
  final String token;
  const ValidarQR(this.token);
  @override
  List<Object?> get props => [token];
}

// ── States ──────────────────────────────────────────────────
abstract class PasseState extends Equatable {
  const PasseState();
  @override
  List<Object?> get props => [];
}

class PasseInitial extends PasseState { const PasseInitial(); }
class PasseLoading extends PasseState { const PasseLoading(); }

class PasseLoaded extends PasseState {
  final Passe passe;
  const PasseLoaded(this.passe);
  @override
  List<Object?> get props => [passe];
}

class QRValidado extends PasseState {
  final bool valido;
  const QRValidado(this.valido);
  @override
  List<Object?> get props => [valido];
}

class PasseError extends PasseState {
  final String message;
  const PasseError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── BLoC ────────────────────────────────────────────────────
class PasseBloc extends Bloc<PasseEvent, PasseState> {
  final GetPasseUseCase  _getPasse;
  final ValidarQRUseCase _validarQR;

  PasseBloc({
    required GetPasseUseCase getPasse,
    required ValidarQRUseCase validarQR,
  })  : _getPasse  = getPasse,
        _validarQR = validarQR,
        super(const PasseInitial()) {
    on<LoadPasse>(_onLoad);
    on<ValidarQR>(_onValidar);
  }

  Future<void> _onLoad(LoadPasse event, Emitter<PasseState> emit) async {
    emit(const PasseLoading());
    final result = await _getPasse(event.alunoId);
    result.fold(
      (f) => emit(PasseError(f.message)),
      (p) => emit(PasseLoaded(p)),
    );
  }

  Future<void> _onValidar(ValidarQR event, Emitter<PasseState> emit) async {
    emit(const PasseLoading());
    final result = await _validarQR(event.token);
    result.fold(
      (f) => emit(PasseError(f.message)),
      (v) => emit(QRValidado(v)),
    );
  }
}