import 'package:get_it/get_it.dart';
import 'data/datasources/local/database_helper.dart';
import 'data/datasources/local/aluno_local_ds.dart';
import 'data/datasources/local/rota_local_ds.dart';
import 'data/datasources/local/passe_local_ds.dart';
import 'data/datasources/local/documento_local_ds.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/rota_repository_impl.dart';
import 'data/repositories/passe_repository_impl.dart';
import 'data/repositories/documento_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/rota_repository.dart';
import 'domain/repositories/passe_repository.dart';
import 'domain/repositories/documento_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/cadastrar_aluno_usecase.dart';
import 'domain/usecases/get_rotas_usecase.dart';
import 'domain/usecases/get_passe_usecase.dart';
import 'domain/usecases/enviar_documento_usecase.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/rotas/rotas_bloc.dart';
import 'presentation/blocs/passe/passe_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Banco de dados ───────────────────────────────────────
  sl.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper.instance,
  );

  // ── DataSources ──────────────────────────────────────────
  sl.registerLazySingleton(() => AlunoLocalDs(sl()));
  sl.registerLazySingleton(() => RotaLocalDs(sl()));
  sl.registerLazySingleton(() => PasseLocalDs(sl()));
  sl.registerLazySingleton(() => DocumentoLocalDs(sl()));

  // ── Repositórios ─────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RotaRepository>(
    () => RotaRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<PasseRepository>(
    () => PasseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DocumentoRepository>(
    () => DocumentoRepositoryImpl(sl()),
  );

  // ── Use Cases ────────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => CadastrarAlunoUseCase(sl()));
  sl.registerLazySingleton(() => GetRotasUseCase(sl()));
  sl.registerLazySingleton(() => GetProximaViagemUseCase(sl()));
  sl.registerLazySingleton(() => GetPasseUseCase(sl()));
  sl.registerLazySingleton(() => ValidarQRUseCase(sl()));
  sl.registerLazySingleton(() => EnviarDocumentoUseCase(sl()));

  // ── BLoCs ────────────────────────────────────────────────
  sl.registerFactory(() => AuthBloc(
    loginUseCase:     sl(),
    cadastrarUseCase: sl(),
  ));
  sl.registerFactory(() => RotasBloc(
    getRotas:         sl(),
    getProximaViagem: sl(),
  ));
  sl.registerFactory(() => PasseBloc(
    getPasse:  sl(),
    validarQR: sl(),
  ));
}