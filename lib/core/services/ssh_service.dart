import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:lg_star_command/core/failures/lg_exception.dart';
import 'package:lg_star_command/core/models/connection_params.dart';

class SSHService {
  SSHClient? _client;

  Future<void> connect(ConnectionParams params) async {
    try {
      final socket = await SSHSocket.connect(
        params.ip,
        params.port,
        timeout: const Duration(seconds: 10),
      );

      _client = SSHClient(
        socket,
        username: params.username,
        onPasswordRequest: () => params.password,
      );

      // Verify connection by running a simple echo command
      await _client!.execute('echo "Connected"');
    } catch (e) {
      throw SSHConnectionException('Failed to connect: $e');
    }
  }

  Future<void> disconnect() async {
    _client?.close();
    await _client?.done;
    _client = null;
  }

  Future<String?> execute(String command) async {
    if (_client == null) {
      throw SSHConnectionException('Not connected to Liquid Galaxy');
    }

    try {
      final session = await _client!.execute(command);
      final stdout = await session.stdout.map((event) => String.fromCharCodes(event)).join();
      return stdout;
    } catch (e) {
      throw SSHExecutionException('Failed to execute command: $e');
    }
  }

  Future<void> upload(File file, String remotePath) async {
    if (_client == null) {
      throw SSHConnectionException('Not connected to Liquid Galaxy');
    }

    try {
      final sftp = await _client!.sftp();
      final remoteFile = await sftp.open(
        remotePath,
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
      );
      await remoteFile.write(file.openRead().cast<Uint8List>());
      await remoteFile.close();
      sftp.close();
    } catch (e) {
      throw SSHExecutionException('Failed to upload file: $e');
    }
  }
  
  bool get isConnected => _client != null && !(_client!.isClosed);
}