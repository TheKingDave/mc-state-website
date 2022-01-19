import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart' as router;

import 'package:dart_minecraft/dart_minecraft.dart' as mc;
import 'package:mc_status/status.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Main {
  Status cache = Status.unknown();
  
  String get jsonCache => jsonEncode(cache.toJson());

  final List<WebSocketChannel> sockets = <WebSocketChannel>[];
  
  Main() {
    init();
  }
  
  void init() async {
    ping();
    Timer.periodic(Duration(seconds: 1), (t) => ping());

    final app = router.Router();

    app.get('/status', getStatus);
    app.get('/ws', webSocketHandler(handleWebsocket));

    final server = await io.serve(app, 'localhost', 8080);
    print('Serving at http://${server.address.host}:${server.port}');
  }
  
  Response getStatus(Request request) {
    return Response.ok(jsonCache, headers: {
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    });
  }
  
  void handleWebsocket(WebSocketChannel websocket) {
    websocket.sink.add(jsonCache);
    websocket.stream.listen((msg) {
      if((msg as String).toLowerCase() == 'get') {
        websocket.sink.add(jsonCache);
      }
    });
    sockets.add(websocket);
  }

  void ping() async {
    final server = await mc.ping('192.168.0.10');
    if (server == null || server.response == null) return;
    final players = server.response!.players;

    updateCache(Status(
      state: State.online,
      ping: server.ping!,
      modt: server.response!.description.description,
      maxPlayers: players.max,
      onlinePlayers: players.online,
      players: players.sample.map((e) => e.name).toList(),
    ));
  }

  void updateCache(Status status) {
    bool notify = cache != status;
    cache = status;
    if(notify) {
      cacheChanged(status);
      print('Notify: $cache');
    }
  }
  
  void cacheChanged(Status status) {
    for(final socket in sockets) {
      socket.sink.add(jsonCache);
    }
  } 
}
