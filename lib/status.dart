import 'package:collection/collection.dart';

enum State {
  unknown,
  offline,
  online,
}

class Status {
  final State state;
  final int? ping;
  final String? modt;
  final int? onlinePlayers;
  final int? maxPlayers;
  final List<String>? players;
  
  Status._(this.state, {this.ping, this.modt, this.onlinePlayers, this.maxPlayers,
      this.players});
  
  factory Status.unknown() => Status._(State.unknown);
  factory Status.offline() => Status._(State.offline);

  Status(
      {required this.state,
      required this.ping,
      required this.modt,
      required this.onlinePlayers,
      required this.maxPlayers,
      required this.players}) {
    players!.sort();
  }

  Map<String, dynamic> toJson() {
    if (state == State.online) {
      return {
        'state': 'ok',
        'ping': ping,
        'modt': modt,
        'onlinePlayers': onlinePlayers,
        'maxPlayers': maxPlayers,
        'players': players,
      };
    }
    return {'state': state.name};
  }

  @override
  String toString() {
    return 'Status: ${ping}ms $onlinePlayers/$maxPlayers $players';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Status &&
          runtimeType == other.runtimeType &&
          modt == other.modt &&
          onlinePlayers == other.onlinePlayers &&
          maxPlayers == other.maxPlayers &&
          ListEquality().equals(players, other.players);

  @override
  int get hashCode =>
      modt.hashCode ^
      onlinePlayers.hashCode ^
      maxPlayers.hashCode ^
      players.hashCode;
}
