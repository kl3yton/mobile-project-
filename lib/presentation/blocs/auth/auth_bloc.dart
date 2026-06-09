import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/cadastrar_aluno_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final CadastrarAlunoUseCase _cadastrarUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required CadastrarAlunoUseCase cadastrarUseCase,
  })  : _loginUseCase    = loginUseCase,
        _cadastrarUseCase = cadastrarUseCase,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<CadastroRequested>(_onCadastro);
    on<LogoutRequested>(_onLogout);
    on<SessaoVerificada>(_onSessao);
  }

  Future<void> _onLogin(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      LoginParams(
        identificador: event.identificador,
        senha:         event.senha,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (aluno)   => emit(AuthAuthenticated(aluno)),
    );
  }

  Future<void> _onCadastro(
    CadastroRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _cadastrarUseCase(
      CadastrarParams(
        nome:      event.nome,
        matricula: event.matricula,
        email:     event.email,
        senha:     event.senha,
        curso:     event.curso,
        periodo:   event.periodo,
        municipio: event.municipio,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (aluno)   => emit(AuthAuthenticated(aluno)),
    );
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated());
  }

  Future<void> _onSessao(
    SessaoVerificada event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthUnauthenticated());
  }
}