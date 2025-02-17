import 'package:awesome_card/extra/card_type.dart';
import 'package:flutter/material.dart';

Widget getCardTypeIcon({CardType? cardType, String? cardNumber}) {
  switch (cardType ?? getCardType(cardNumber!)) {
    case CardType.americanExpress:
      return Image.asset(
        'images/card_provider/american_express.png',
        width: 55,
        height: 40,
        package: 'awesome_card',
      );
    case CardType.dinersClub:
      return Image.asset(
        'images/card_provider/diners_club.png',
        width: 40,
        height: 40,
        package: 'awesome_card',
      );
    case CardType.discover:
      return Image.asset(
        'images/card_provider/discover.png',
        width: 70,
        height: 50,
        package: 'awesome_card',
      );
    case CardType.jcb:
      return Image.asset(
        'images/card_provider/jcb.png',
        width: 40,
        height: 40,
        package: 'awesome_card',
      );
    case CardType.masterCard:
      return Image.asset(
        'images/card_provider/master_card.png',
        width: 55,
        height: 40,
        package: 'awesome_card',
      );
    case CardType.maestro:
      return Image.asset(
        'images/card_provider/maestro.png',
        width: 55,
        height: 40,
        package: 'awesome_card',
      );
    case CardType.rupay:
      return Image.asset(
        'images/card_provider/rupay.png',
        width: 80,
        height: 50,
        package: 'awesome_card',
      );
    case CardType.visa:
      return Image.asset(
        'images/card_provider/visa.png',
        width: 55,
        height: 40,
        package: 'awesome_card',
      );
    case CardType.elo:
      return Image.asset(
        'images/card_provider/elo.png',
        width: 50,
        height: 50,
        package: 'awesome_card',
      );
    case CardType.union:
      return Image.asset(
        'images/card_provider/union.png',
        width: 50,
        height: 50,
        package: 'awesome_card',
      );
    default:
      return Container();
  }
}

/// https://baymard.com/checkout-usability/credit-card-patterns
String getCardTypeMask({CardType? cardType, String? cardNumber}) {
  final trimmedCardLength = cardNumber?.replaceAll(' ', '').length;
  switch (cardType ?? getCardType(cardNumber!)) {
    case CardType.americanExpress:
      return 'XXXX XXXXXX XXXXX';

    case CardType.dinersClub:
      if (trimmedCardLength == 14) {
        return 'XXXX XXXXXX XXXX';
      }
      return 'XXXX XXXX XXXX XXXX';

    case CardType.discover:
      return 'XXXX XXXX XXXX XXXX';

    case CardType.jcb:
      return 'XXXX XXXX XXXX XXXX';

    case CardType.masterCard:
      return 'XXXX XXXX XXXX XXXX';

    case CardType.maestro:
      if (trimmedCardLength == 13) {
        return 'XXXX XXXX XXXXX';
      } else if (trimmedCardLength == 15) {
        return 'XXXX XXXXXX XXXXX';
      } else if (trimmedCardLength == 19) {
        return 'XXXX XXXX XXXX XXXX XXX';
      }
      return 'XXXX XXXX XXXX XXXX';

    case CardType.rupay:
      return 'XXXX XXXX XXXX XXXX';

    case CardType.visa:
      return 'XXXX XXXX XXXX XXXX';

    case CardType.elo:
      return 'XXXX XXXX XXXX XXXX';
    case CardType.union:
      return 'XXXX XXXX XXXX XXXX';
    default:
      return 'XXXX XXXX XXXX XXXX';
  }
}

CardType getCardType(String cardNumber) {
  final rAmericanExpress = RegExp(r'^3[47][0-9]{0,}$');
  final rDinersClub = RegExp(r'^3(?:0[0-59]{1}|[689])[0-9]{0,}$');
  final rDiscover = RegExp(
      r'^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]{0,}$');
  final rJcb = RegExp(r'^(?:2131|1800|35)[0-9]{0,}$');
  final rMasterCard =
      RegExp(r'^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$');
  final rMaestro = RegExp(r'^(5018|5020|5038|5893|6304|6759|6761|6762|6763)[0-9]{8,15}$');
  final rRupay = RegExp(r'^(6522|6521|60)[0-9]{0,}$');
  final rVisa = RegExp(r'^4[0-9]{0,}$');
  final rUnion = RegExp(r'^(62[0-9]{14,17})$');
  final rElo = RegExp(
      r'^(4011(78|79)|43(1274|8935)|45(1416|7393|763(1|2))|50(4175|6699|67[0-7][0-9]|9000)|50(9[0-9][0-9][0-9])|627780|63(6297|6368)|650(03([^4])|04([0-9])|05(0|1)|05([7-9])|06([0-9])|07([0-9])|08([0-9])|4([0-3][0-9]|8[5-9]|9[0-9])|5([0-9][0-9]|3[0-8])|9([0-6][0-9]|7[0-8])|7([0-2][0-9])|541|700|720|727|901)|65165([2-9])|6516([6-7][0-9])|65500([0-9])|6550([0-5][0-9])|655021|65505([6-7])|6516([8-9][0-9])|65170([0-4]))');

  // Remove all the spaces from the card number
  cardNumber = cardNumber.trim().replaceAll(' ', '');

  if (rAmericanExpress.hasMatch(cardNumber)) {
    return CardType.americanExpress;
  } else if (rMasterCard.hasMatch(cardNumber)) {
    return CardType.masterCard;
  } else if (rVisa.hasMatch(cardNumber)) {
    return CardType.visa;
  } else if (rDinersClub.hasMatch(cardNumber)) {
    return CardType.dinersClub;
  } else if (rRupay.hasMatch(cardNumber)) {
    // Additional check to see if it's a discover card
    // Some discover card starts with 6011 and some rupay card starts with 60
    // If the card number matches the 6011 then it must be discover.

    // Note: Keep rupay check before the discover check
    if (rDiscover.hasMatch(cardNumber)) {
      return CardType.discover;
    } else {
      return CardType.rupay;
    }
  } else if (rDiscover.hasMatch(cardNumber)) {
    return CardType.discover;
  } else if (rJcb.hasMatch(cardNumber)) {
    return CardType.jcb;
  } else if (rElo.hasMatch(cardNumber)) {
    return CardType.elo;
  } else if (rMaestro.hasMatch(cardNumber)) {
    return CardType.maestro;
  }else if (rUnion.hasMatch(cardNumber)) {
    return CardType.union;
  }

  return CardType.other;
}
class MaskedTextController extends TextEditingController {
  MaskedTextController(
      {String? text, required this.mask, Map<String, RegExp>? translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (beforeChange(previous, this.text)) {
        updateText(this.text);
        afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  late Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text.isNotEmpty) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection = TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return <String, RegExp>{
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String? mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask!.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar]!.hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}