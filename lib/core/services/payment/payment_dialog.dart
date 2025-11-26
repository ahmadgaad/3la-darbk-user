import 'package:flutter/material.dart';

import 'myfatoraah.dart';

class Payment {
  static Future pay(context, amount) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PaymentDialog(paymentAmount: amount);
      },
    );
  }
}
