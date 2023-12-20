import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:humantek_task/screens/home2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set the publishable key for Stripe - this is mandatory
  Stripe.publishableKey =
      'pk_test_51OOy3uDC62mLUVol9gL1EyUxfjH0eRnkU9u0c4l4IuVUW4tq7cgJky8jMfaXNG6IzTjlMudOBWpUNBKhxZwekhTM00MeOoqFO6';
  await dotenv.load(fileName: 'assets/.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: hometwo(),
    );
  }
}
