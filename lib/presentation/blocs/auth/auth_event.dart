import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String identificador;
  final String senha;

  const LoginRequested({
    required this.identificador,
    required this.senha,
  });

  @override
  List<Object?> get props => [identificador, senha];
}

class CadastroRequested extends AuthEvent {
  final String nome;
  final String matricula;
  final String email;
  final String senha;
  final String? curso;
  final int? periodo;
  final String? municipio;

  const CadastroRequested({
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha,
    this.curso,
    this.periodo,
    this.municipio,
  });

  @override
  List<Object?> get props => [nome, matricula, email, senha];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class SessaoVerificada extends AuthEvent {
  const SessaoVerificada();
}