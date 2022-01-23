import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart' show load, env;

class Config {
  late final int port;
  final String hostname;
  final String server;
  final String webPath;

  Config._(
      {required this.port,
      required this.hostname,
      required this.server,
      required this.webPath});

  Config._str(
      {required String port,
      required this.hostname,
      required this.server,
      required this.webPath}) {
    this.port = int.parse(port);
  }

  factory Config(List<String> arguments) {
    final parser = ArgParser();
    parser.addOption('port', abbr: 'p');
    parser.addOption('hostname', abbr: 'h');
    parser.addOption('server', abbr: 's');
    parser.addOption('webPath', abbr: 'w');

    final result = parser.parse(arguments);

    load();
    return Config._str(
      port: result['port'] ?? env['PORT'] ?? '8000',
      hostname: result['hostname'] ?? env['HOSTNAME'] ?? '0.0.0.0',
      server: result['server'] ?? env['SERVER'] ?? 'localhost',
      webPath: result['webPath'] ?? env['WEB_PATH'] ?? 'web/public',
    );
  }
}
