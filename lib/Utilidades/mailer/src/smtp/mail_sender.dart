import 'dart:async';

import 'package:logging/logging.dart';
import 'package:goshare/Utilidades/mailer/src/smtp/validator.dart';

import '../../mailer.dart';
import '../../smtp_server.dart';
import 'connection.dart';
import 'exceptions.dart';
import 'smtp_client.dart' as client;

final Logger _logger = new Logger('mailer_sender');

class _MailSendTask {
  // If [message] is `null` close connection.
  Message? message;
  Completer<SendReport>? completer;
}

class PersistentConnection {
  Connection? _connection;

  final mailSendTasksController = new StreamController<_MailSendTask>();
  Stream<_MailSendTask> get mailSendTasks => mailSendTasksController.stream;

  PersistentConnection(SmtpServer smtpServer, {Duration? timeout}) {
    mailSendTasks.listen((_MailSendTask task) async {
      _logger.finer('New mail sending task.  ${task.message?.subject}');
      try {
        if (task.message == null) {
          // Close connection.
          if (_connection != null) {
            //comentario tratamento flutter v2
            //await client.close(_connection);
          }
          task.completer?.complete(null);
          return;
        }

        if (_connection == null) {
          
            //comentario tratamento flutter v2
          // _connection = await client.connect(smtpServer, timeout);
        }
        //comentario tratamento flutter v2
        // var report = await _send(task.message, _connection, timeout);
        // task.completer.complete(report);
      } catch (e) {
        _logger.fine('Completing with error: $e');
        task.completer?.completeError(e);
      }
    });
  }

  /// Throws following exceptions:
  /// [SmtpClientAuthenticationException],
  /// [SmtpUnsecureException],
  /// [SmtpClientCommunicationException],
  /// [SocketException]     // Connection dropped
  
  
  //comentario tratamento flutter v2
  ///// Please report other exceptions you encounter.
  // Future<SendReport> send(Message message) {
  //   _logger.finer('Adding message to mailSendQueue');
  //   var mailTask = _MailSendTask()
  //     ..message = message
  //     ..completer = Completer();
  //   mailSendTasksController.add(mailTask);
  //   return mailTask.completer.future;
  // }

  /// Throws following exceptions:
  /// [SmtpClientAuthenticationException],
  /// [SmtpUnsecureException],
  /// [SmtpClientCommunicationException],
  /// [SocketException]
  /// Please report other exceptions you encounter.
  Future<void> close() async {
    _logger.finer('Adding "close"-message to mailSendQueue');
    var closeTask = _MailSendTask()..completer = Completer();
    mailSendTasksController.add(closeTask);
    try {
      
            //comentario tratamento flutter v2
      // await closeTask.completer.future;
    } finally {
      await mailSendTasksController.close();
    }
  }
}

/// Throws following exceptions:
/// [SmtpClientAuthenticationException],
/// [SmtpClientCommunicationException],
/// [SocketException]
/// [SmtpMessageValidationException]
/// Please report other exceptions you encounter.
            //comentario tratamento flutter v2
// Future<SendReport> send(Message message, SmtpServer smtpServer,
//     {Duration? timeout}) async {
//   _validate(message);
//   var connection = await client.connect(smtpServer, timeout);
//   var sendReport = await _send(message, connection, timeout);
//   await client.close(connection);
//   return sendReport;
// }

/// Convenience method for testing SmtpServer configuration.
///
/// Throws following exceptions if the configuration is incorrect or there is
/// no internet connection:
/// [SmtpClientAuthenticationException],
/// [SmtpClientCommunicationException],
/// [SocketException]
/// others

            //comentario tratamento flutter v2
// Future<void> checkCredentials(SmtpServer smtpServer, {Duration timeout}) async {
//   var connection = await client.connect(smtpServer, timeout);
//   await client.close(connection);
// }

            //comentario tratamento flutter v2
/// [SmtpMessageValidationException]
// void _validate(Message message) async {
//   var validationProblems = validate(message);
//   if (validationProblems.isNotEmpty) {
//     _logger.severe('Message validation error: '
//         '${validationProblems.map((p) => p.msg).join('|')}');
//     throw SmtpMessageValidationException(
//         'Invalid message.', validationProblems);
//   }
// }

/// Connection [connection] must already be connected.
/// Throws following exceptions:
/// [SmtpClientCommunicationException],
/// [SocketException]
/// Please report other exceptions you encounter.
Future<SendReport> _send(
    Message message, Connection connection, Duration timeout) async {
  DateTime messageSendStart = DateTime.now();
  DateTime messageSendEnd;
  try {
    await client.sendSingleMessage(message, connection, timeout);
    messageSendEnd = DateTime.now();
  } catch (e) {
    _logger.warning('Could not send mail.', e);
    rethrow;
  }
  return SendReport(message, connection.connectionOpenStart, messageSendStart,
      messageSendEnd);
}
