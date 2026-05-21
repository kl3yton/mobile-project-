import 'package:mysql_client/mysql_client.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper _instance =
      DatabaseHelper._privateConstructor();

  static DatabaseHelper get instance => _instance;

  MySQLConnection? _connection;

  static const String _host     = '127.0.0.1';
  static const int    _port     = 3306;
  static const String _user     = 'root';
  static const String _password = 'sua_senha'; // ← altere aqui
  static const String _database = 'unipass_db';

  Future<MySQLConnection> get connection async {
    if (_connection != null && _connection!.connected) {
      return _connection!;
    }

    _connection = await MySQLConnection.createConnection(
      host:         _host,
      port:         _port,
      userName:     _user,
      password:     _password,
      databaseName: _database,
    );

    await _connection!.connect();
    return _connection!;
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
}