import 'package:awesome_card/awesome_card.dart';
import 'package:awesome_card/credit_card_model.dart';
import 'package:flutter/material.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.obscureCvv = false,
    this.obscureNumber = false,
    required this.onCreditCardModelChange,
    required this.themeColor,
    this.textColor = Colors.black,
    this.cursorColor,
    this.cardHolderDecoration = const InputDecoration(
      labelText: 'Card holder',
    ),
    this.cardNumberDecoration = const InputDecoration(
      labelText: 'Card number',
      hintText: 'XXXX XXXX XXXX XXXX',
    ),
    this.expiryDateDecoration = const InputDecoration(
      labelText: 'Expired Date',
      hintText: 'MM/YY',
    ),
    this.cvvCodeDecoration = const InputDecoration(
      labelText: 'CVV',
      hintText: 'XXX',
    ),
    required this.formKey,
    this.cardNumberKey,
    this.cardHolderKey,
    this.expiryDateKey,
    this.cvvCodeKey,
    this.cvvValidationMessage = 'Please input a valid CVV',
    this.dateValidationMessage = 'Please input a valid date',
    this.numberValidationMessage = 'Please input a valid number',
    this.isHolderNameVisible = true,
    this.isCardNumberVisible = true,
    this.isExpiryDateVisible = true,
    this.autovalidateMode,
    this.cardNumberValidator,
    this.expiryDateValidator,
    this.cvvValidator,
    this.cardHolderValidator,
    this.onFormComplete, required this.cvvFocusNode,
  }) : super(key: key);

  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final String cvvValidationMessage;
  final String dateValidationMessage;
  final String numberValidationMessage;
  final void Function(CreditCardModel) onCreditCardModelChange;
  final Color themeColor;
  final Color textColor;
  final Color? cursorColor;
  final bool obscureCvv;
  final bool obscureNumber;
  final bool isHolderNameVisible;
  final bool isCardNumberVisible;
  final bool isExpiryDateVisible;
  final FocusNode cvvFocusNode;
  final GlobalKey<FormState> formKey;
  final Function? onFormComplete;

  final GlobalKey<FormFieldState<String>>? cardNumberKey;
  final GlobalKey<FormFieldState<String>>? cardHolderKey;
  final GlobalKey<FormFieldState<String>>? expiryDateKey;
  final GlobalKey<FormFieldState<String>>? cvvCodeKey;

  final InputDecoration cardNumberDecoration;
  final InputDecoration cardHolderDecoration;
  final InputDecoration expiryDateDecoration;
  final InputDecoration cvvCodeDecoration;
  final AutovalidateMode? autovalidateMode;

  final String? Function(String?)? cardNumberValidator;
  final String? Function(String?)? expiryDateValidator;
  final String? Function(String?)? cvvValidator;
  final String? Function(String?)? cardHolderValidator;

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  bool isCvvFocused = false;
  late Color themeColor;

  late void Function(CreditCardModel) onCreditCardModelChange;
  late CreditCardModel creditCardModel;

  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

 // FocusNode cvvFocusNode = FocusNode();
  FocusNode expiryDateNode = FocusNode();
  FocusNode cardHolderNode = FocusNode();

  void textFieldFocusDidChange() {
    creditCardModel.isCvvFocused = widget.cvvFocusNode.hasFocus;
    onCreditCardModelChange(creditCardModel);
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;

    creditCardModel = CreditCardModel(
        cardNumber, expiryDate, cardHolderName, cvvCode, isCvvFocused);
  }

  @override
  void initState() {
    super.initState();

    createCreditCardModel();

    _cardNumberController.text = widget.cardNumber;
    _expiryDateController.text = widget.expiryDate;
    _cardHolderNameController.text = widget.cardHolderName;
    _cvvCodeController.text = widget.cvvCode;

    onCreditCardModelChange = widget.onCreditCardModelChange;

    widget.cvvFocusNode.addListener(textFieldFocusDidChange);
  }

  @override
  void dispose() {
    cardHolderNode.dispose();
    expiryDateNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: <Widget>[
            Visibility(
              visible: widget.isCardNumberVisible,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: TextFormField(
                  key: widget.cardNumberKey,
                  obscureText: widget.obscureNumber,
                  controller: _cardNumberController,
                  onChanged: (String value) {
                    setState(() {
                      cardNumber = _cardNumberController.text;
                      creditCardModel.cardNumber = cardNumber;
                      onCreditCardModelChange(creditCardModel);
                    });
                  },
                  cursorColor: widget.cursorColor ?? themeColor,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(expiryDateNode);
                  },
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                  decoration: widget.cardNumberDecoration,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofillHints: const <String>[AutofillHints.creditCardNumber],
                  autovalidateMode: widget.autovalidateMode,
                  validator: widget.cardNumberValidator ??
                      (String? value) {
                        // Validate less that 13 digits +3 white spaces
                        if (value!.isEmpty || value.length < 16) {
                          return widget.numberValidationMessage;
                        }
                        return null;
                      },
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Visibility(
                  visible: widget.isExpiryDateVisible,
                  child: Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin:
                          const EdgeInsets.only(left: 16, top: 8, right: 16),
                      child: TextFormField(
                        key: widget.expiryDateKey,
                        controller: _expiryDateController,
                        onChanged: (String value) {
                          if (_expiryDateController.text
                              .startsWith(RegExp('[2-9]'))) {
                            _expiryDateController.text =
                                '0' + _expiryDateController.text;
                          }
                          setState(() {
                            expiryDate = _expiryDateController.text;
                            creditCardModel.expiryDate = expiryDate;
                            onCreditCardModelChange(creditCardModel);
                          });
                        },
                        cursorColor: widget.cursorColor ?? themeColor,
                        focusNode: expiryDateNode,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(widget.cvvFocusNode);
                        },
                        style: TextStyle(
                          color: widget.textColor,
                        ),
                        decoration: widget.expiryDateDecoration,
                        keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                        textInputAction: TextInputAction.next,
                        autofillHints: const <String>[
                          AutofillHints.creditCardExpirationDate
                        ],
                        validator: widget.expiryDateValidator ??
                            (String? value) {
                              if (value!.isEmpty) {
                                return widget.dateValidationMessage;
                              }
                              final now = DateTime.now();
                              final date =
                                  value.split(RegExp(r'/'));
                              final month = int.parse(date.first);
                              final year = int.parse('20${date.last}');
                              final lastDayOfMonth = month < 12
                                  ? DateTime(year, month + 1, 0).day
                                  : DateTime(year + 1, 1, 0).day;
                              final cardDate = DateTime(
                                  year, month, lastDayOfMonth, 23, 59, 59, 999);

                              if (cardDate.isBefore(now) ||
                                  month > 12 ||
                                  month == 0) {
                                return widget.dateValidationMessage;
                              }
                              return null;
                            },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: TextFormField(
                      key: widget.cvvCodeKey,
                      obscureText: widget.obscureCvv,
                      focusNode: widget.cvvFocusNode,
                      controller: _cvvCodeController,
                      cursorColor: widget.cursorColor ?? themeColor,
                      onEditingComplete: () {
                        if (widget.isHolderNameVisible) {
                          FocusScope.of(context).requestFocus(cardHolderNode);
                        } else {
                          FocusScope.of(context).unfocus();
                          onCreditCardModelChange(creditCardModel);
                          if (widget.onFormComplete != null) {
                            widget.onFormComplete!();
                          }
                        }
                      },
                      style: TextStyle(
                        color: widget.textColor,
                      ),
                      decoration: widget.cvvCodeDecoration,
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                      textInputAction: widget.isHolderNameVisible
                          ? TextInputAction.next
                          : TextInputAction.done,
                      autofillHints: const <String>[
                        AutofillHints.creditCardSecurityCode
                      ],
                      onChanged: (String text) {
                        setState(() {
                          cvvCode = text;
                          creditCardModel.cvvCode = cvvCode;
                          onCreditCardModelChange(creditCardModel);
                        });
                      },
                      validator: widget.cvvValidator ??
                          (String? value) {
                            if (value!.isEmpty || value.length < 3) {
                              return widget.cvvValidationMessage;
                            }
                            return null;
                          },
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: widget.isHolderNameVisible,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: TextFormField(
                  key: widget.cardHolderKey,
                  controller: _cardHolderNameController,
                  onChanged: (String value) {
                    setState(() {
                      cardHolderName = _cardHolderNameController.text;
                      creditCardModel.cardHolderName = cardHolderName;
                      onCreditCardModelChange(creditCardModel);
                    });
                  },
                  cursorColor: widget.cursorColor ?? themeColor,
                  focusNode: cardHolderNode,
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                  decoration: widget.cardHolderDecoration,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autofillHints: const <String>[AutofillHints.creditCardName],
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    onCreditCardModelChange(creditCardModel);
                    if (widget.onFormComplete != null) {
                      widget.onFormComplete!();
                    }
                  },
                  validator: widget.cardHolderValidator,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
