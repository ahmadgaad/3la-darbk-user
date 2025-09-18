import 'package:ala_darbak_user/core/utils/payment/myfatoraah.dart';
import 'package:flutter/material.dart';

class Payment {
  static Future pay(context, amount) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  PaymentPage(paymentAmount: amount,);
      },
    );
  }
}
