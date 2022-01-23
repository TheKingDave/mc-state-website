import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart' show load, env;

class Config {
  late final int port;
  final String host;
  final String server;
  final String webPath;

  Config._(
      {required this.port,
      required this.host,
      required this.server,
      required this.webPath});

  Config._str(
      {required String port,
      required this.host,
      required this.server,
      required this.webPath}) {
    this.port = int.parse(port);
  }

  factory Config(List<String> arguments) {
    final parser = ArgParser();
    parser.addOption('port', abbr: 'p');
    parser.addOption('host', abbr: 'h');
    parser.addOption('server', abbr: 's');
    parser.addOption('webPath', abbr: 'w');

    final result = parser.parse(arguments);

    print(env);
    load();
    print(env);

    return Config._str(
      port: result['port'] ?? env['PORT'] ?? '8000',
      host: result['host'] ?? env['HOST'] ?? '127.0.0.1',
      server: result['server'] ?? env['SERVER'] ?? '127.0.0.1',
      webPath: result['webPath'] ?? env['WEB_PATH'] ?? 'web/public',
    );
  }
}
