import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';

class hometwo extends StatefulWidget {
  const hometwo({super.key});

  @override
  State<hometwo> createState() => _hometwoState();
}

class _hometwoState extends State<hometwo> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Tutorial'),
      ),
      body: Center(
        child: InkWell(
          onTap: () async {
            // final paymentMethod = await Stripe.instance.createPaymentMethod(
            //     params: const PaymentMethodParams.card(
            //         paymentMethodData: PaymentMethodData()));
            await stripeMakePayment();
            // await initPaymentSheet();
            // await displayPaymentSheet();
          },
          child: Container(
            height: 50,
            width: 200,
            color: Colors.indigo,
            child: const Center(
              child: Text(
                'Pay',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> stripeMakePayment() async {
    try {
      paymentIntentData = await createPaymentIntent('100', 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  // setupIntentClientSecret:
                  //     'sk_test_51OOy3uDC62mLUVolTH8e9UZiLQw16XATPRWPsTr45rbaRW01JzbQM0pBCAEKYXXWWJoMgbAB7PzGVQghHaLT3Zq900csI2qFGG',
                  billingDetails: const BillingDetails(
                      name: 'YOUR NAME',
                      email: 'YOUREMAIL@gmail.com',
                      phone: 'YOUR NUMBER',
                      address: Address(
                          city: 'YOUR CITY',
                          country: 'YOUR COUNTRY',
                          line1: 'YOUR ADDRESS 1',
                          line2: 'YOUR ADDRESS 2',
                          postalCode: 'YOUR PINCODE',
                          state: 'YOUR STATE')),
                  paymentIntentClientSecret: paymentIntentData![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});
      print(
          '==================================DONE===========================');
      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer ${dotenv.env['sk_test_51OOy3uDC62mLUVolTH8e9UZiLQw16XATPRWPsTr45rbaRW01JzbQM0pBCAEKYXXWWJoMgbAB7PzGVQghHaLT3Zq900csI2qFGG']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
