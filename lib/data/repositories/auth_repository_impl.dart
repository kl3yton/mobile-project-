import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/aluno.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/aluno_local_ds.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AlunoLocalDs _ds;

  AuthRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, Aluno>> login({
    required String identificador,
    required String senha,
  }) async {
    try {
      final aluno = await _ds.findByCredencial(identificador);

      if (aluno == null) {
        return Left(const AuthFailure('Usuário não encontrado'));
      }

      // Busca a senha hash direto no banco para comparar
      final conn   = await _ds.db.connection;
      final result = await conn.execute(
        'SELECT senha_hash FROM alunos WHERE id = :id LIMIT 1',
        {'id': aluno.id},
      );

      if (result.rows.isEmpty) {
        return Left(const AuthFailure('Erro ao verificar senha'));
      }

      final senhaHash = result.rows.first.assoc()['senha_hash'];

      if (senhaHash != senha) {
        return Left(const AuthFailure('Senha incorreta'));
      }

      return Right(aluno);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao conectar: $e'));
    }
  }

  @override
  Future<Either<Failure, Aluno>> cadastrar({
    required String nome,
    required String matricula,
    required String email,
    required String senha,
    String? curso,
    int? periodo,
    String? municipio,
  }) async {
    try {
      final existe = await _ds.findByMatricula(matricula);
      if (existe != null) {
        return Left(const AuthFailure('Matrícula já cadastrada'));
      }
      final aluno = await _ds.insert({
        'nome':      nome,
        'matricula': matricula,
        'email':     email,
        'senha':     senha,
        'curso':     curso,
        'periodo':   periodo,
        'municipio': municipio,
      });
      return Right(aluno);
    } catch (e) {
      return Left(DatabaseFailure('Erro ao cadastrar: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, Aluno?>> getSessaoAtiva() async {
    return const Right(null);
  }
}