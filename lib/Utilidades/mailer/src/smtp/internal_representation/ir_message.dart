part of 'internal_representation.dart';

class IRMessage {
  final Message _message;
  _IRContent? _content;

  // Possibly throws.
  IRMessage(this._message) {
    var headers = _buildHeaders(_message);
    _content = _IRContentPartMixed(_message, headers);
  }

  Iterable<String> get envelopeTos {
    // All recipients.
    Iterable<String> envelopeTos = _message.envelopeTos ?? [];

    if (envelopeTos.isEmpty) {
      //var a = _message.recipientsAsAddresses.first.mailAddress;
      // envelopeTos = [
      //   ..._message.recipientsAsAddresses,
      //   ..._message.ccsAsAddresses,
      //   ..._message.bccsAsAddresses
      // ].where((a) => a?.mailAddress != null).map((a) => a.mailAddress);
      //envelopeTos = [_message.recipientsAsAddresses.toString(),_message.ccsAsAddresses.toString(),_message.bccsAsAddresses.toString()];
      envelopeTos = [_message?.recipientsAsAddresses?.first?.mailAddress ?? ""];
    }
    return envelopeTos;
  }

  String get envelopeFrom =>
      _message.envelopeFrom ?? _message.fromAsAddress?.mailAddress ?? '';

  Stream<List<int>> ? data(Capabilities capabilities){
     _content?.out(_IRMetaInformation(capabilities));
  }
}

class InvalidHeaderException implements Exception {
  String message;
  InvalidHeaderException(this.message);
}
