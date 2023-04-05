import 'package:goshare/Utilidades/mailer/src/entities/problem.dart';
import 'package:goshare/Utilidades/mailer/src/smtp/internal_representation/internal_representation.dart';
import 'package:goshare/Utilidades/mailer/src/utils.dart';

import '../entities/address.dart';
import '../entities/message.dart';

bool _printableCharsOnly(String s) {
  return isPrintableRegExp.hasMatch(s);
}

/// [address] can either be an [Address] or String.
bool _validAddress(dynamic addressIn) {
  Address address =
      addressIn is String ? Address(addressIn) : addressIn as Address;

  if (addressIn == null) return false;
  return _printableCharsOnly(address.name ?? '') ;
    //comentado para atualização do flutter v2
    // && _validMailAddress(address.mailAddress);
}

bool _validMailAddress(String ma) {
  var split = ma.split('@');
  return split.length == 2 &&
      split.every((part) => part.isNotEmpty && _printableCharsOnly(part));
}

List<Problem> validate(Message message) {
  List<Problem> res = <Problem>[];

  var validate = (bool isValid, String code, String msg) {
    if (!isValid) {
      res.add(Problem(code, msg));
    }
  };

  validate(
      _validMailAddress(
          (message.envelopeFrom??"") ?? (message.fromAsAddress.mailAddress??"")),
      'ENV_FROM',
      'Envelope mail address is invalid.  ${message.envelopeFrom}');
  int counter = 0;
  (message.envelopeTos ?? <String>[]).forEach((a) {
    counter++;
    validate((a != null && a.isNotEmpty), 'ENV_TO_EMPTY',
        'Envelope to address (pos: $counter) is null or empty');
    validate(
        _validMailAddress(a), 'ENV_TO', 'Envelope to address is invalid.  $a');
  });

  validate(_validAddress(message.from), 'FROM_ADDRESS',
      'The from address is invalid.  (${message.from})');
  counter = 0;
  message.recipients.forEach((aIn) {
    counter++;
    Address a;

    a = aIn is String ? Address(aIn) : aIn as Address;

    validate(
        a != null && (a.mailAddress ?? '').isNotEmpty,
        'FROM_ADDRESS_EMPTY',
        'A recipient address is null or empty.  (pos: $counter).');
    if (a != null) {
      validate(_validAddress(a), 'FROM_ADDRESS',
          'A recipient address is invalid.  ($a).');
    }
  });
  try {
    IRMessage irMessage = IRMessage(message);
    if (irMessage.envelopeTos.isEmpty) {
      res.add(Problem('NO_RECIPIENTS', 'Mail does not have any recipients.'));
    }
  } on InvalidHeaderException catch (e) {
    res.add(Problem('INVALID_HEADER', e.message));
  } catch (e) {
    res.add(
        Problem('INVALID_MESSAGE', 'Could not build internal representation.'));
  }
  return res;
}
