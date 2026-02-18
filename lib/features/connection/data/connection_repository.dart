import 'dart:convert';
import 'package:lg_star_command/core/models/connection_params.dart';
import 'package:lg_star_command/core/services/ssh_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectionRepository {
  final SSHService _sshService;
  final SharedPreferences _prefs;

  ConnectionRepository(this._sshService, this._prefs);

  static const String _storageKey = 'lg_connection_params';

  Future<void> connect(ConnectionParams params) async {
    await _sshService.connect(params);
    await _saveParams(params);
  }

  Future<void> disconnect() async {
    await _sshService.disconnect();
  }
  
  bool get isConnected => _sshService.isConnected;

  Future<ConnectionParams?> getSavedParams() async {
    final jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return ConnectionParams(
        ip: json['ip'] as String,
        port: json['port'] as int,
        username: json['username'] as String,
        password: json['password'] as String,
        screenCount: json['screenCount'] as int,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveParams(ConnectionParams params) async {
    final Map<String, dynamic> json = {
      'ip': params.ip,
      'port': params.port,
      'username': params.username,
      'password': params.password,
      'screenCount': params.screenCount,
    };
    await _prefs.setString(_storageKey, jsonEncode(json));
  }
}
