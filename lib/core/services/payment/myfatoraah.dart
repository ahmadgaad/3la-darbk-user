import 'package:ala_darbak_user/core/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

// Replace with your actual API key
const String apiKey =
    "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL";

class PaymentPage extends StatefulWidget {
  final dynamic paymentAmount; // Default payment amount

  const PaymentPage({super.key, this.paymentAmount});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<MFPaymentMethod> paymentMethods = [];
  int? selectedPaymentMethodId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  // Initialize MyFatoorah SDK and fetch payment methods
  Future<void> _initializePayment() async {
    setState(() {
      isLoading = true;
    });
    print('Initializing MFSDK...');
    try {
      await MFSDK.init(apiKey, MFCountry.SAUDIARABIA, MFEnvironment.TEST);
      print('MFSDK initialized successfully.');
      await _fetchPaymentMethods();
    } catch (e) {
      print('Error initializing MFSDK: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error initializing payment system')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  // Fetch payment methods
  Future<void> _fetchPaymentMethods() async {
    print('Fetching payment methods...');
    var request = MFInitiatePaymentRequest(
      invoiceAmount: widget.paymentAmount,

      currencyIso: MFCurrencyISO.SAUDIARABIA_SAR, // Change currency if needed
    );
    try {
      var result = await MFSDK.initiatePayment(request, MFLanguage.ARABIC);
      print('Payment methods fetched successfully: $result');
      setState(() {
        paymentMethods = result.paymentMethods ?? [];
      });
      if (paymentMethods.isEmpty) {
        print("no payment method exist");
      }
    } catch (e) {
      print('Error fetching payment methods: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load payment methods')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.choose_payment_way.tr()),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height *
              0.7, // Limit the dialog height
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        paymentMethods.map((method) {
                          return RadioListTile<int>(
                            title: Row(
                              children: [
                                if (method.imageUrl != null)
                                  Image.network(
                                    method.imageUrl!,
                                    width: 40,
                                    height: 40,
                                  ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(method.paymentMethodEn ?? ""),
                                ),
                              ],
                            ),
                            value: method.paymentMethodId!,
                            groupValue: selectedPaymentMethodId,
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentMethodId = value;
                              });
                            },
                          );
                        }).toList(),
                  ),
                ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (selectedPaymentMethodId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a payment method')),
              );
              return;
            }

            var request = MFExecutePaymentRequest(
              invoiceValue: widget.paymentAmount,
              paymentMethodId: selectedPaymentMethodId!,
            );
            request.displayCurrencyIso =
                MFCurrencyISO.SAUDIARABIA_SAR; // Change currency if needed
            bool isSuccess = false;
            try {
              final myFatoResponse = await MFSDK.executePayment(
                request,
                MFLanguage.ARABIC,

                (invoiceId) {
                  print('Invoice ID: $invoiceId');
                },
              );
              print("Invoice Status: ${myFatoResponse.invoiceStatus}");
              isSuccess = myFatoResponse.invoiceStatus?.toLowerCase() == "paid";
            } catch (e) {
              if (e is MFError) {
                print('Error executing payment: ${e.message}');
                print('Error executing payment: ${e.code}');
              } else {
                print('Error executing payment: $e');
              }
            }
            Navigator.pop(context, isSuccess); // Close the dialog
          },
          child: Text(LocaleKeys.pay_now.tr()),
        ),
      ],
    );
  }
}
