import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ledger/screens/ForgotPassword/email_recovery.dart';
import 'package:flutter_ledger/screens/payment.dart';
import 'package:flutter_ledger/services/db.dart';
import 'package:flutter_ledger/services/auth.dart';
import 'package:flutter_ledger/screens/screens.dart';
import 'package:flutter_ledger/services/models.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MultiProvider(
        providers: [
          StreamProvider<User>.value(
            value: AuthService().user,
            initialData: null,
          ),
        ],
        child: MaterialApp(
          routes: {
            '/': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
            '/forgotPassword': (context) => EmailRecovery(),
            '/payment': (context) => PaymentScreen(),
          },

          // Theme
          theme: ThemeData(
            fontFamily: 'Nunito',
            bottomAppBarTheme: BottomAppBarTheme(
              color: Colors.black87,
            ),
            // your customizations here
            brightness: Brightness.light,
            textTheme: TextTheme(
              bodyText1: TextStyle(fontSize: 18),
              bodyText2: TextStyle(fontSize: 16),
              button:
                  TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
              headline5: TextStyle(fontWeight: FontWeight.bold),
              subtitle1: TextStyle(color: Colors.grey),
            ),
            buttonTheme: ButtonThemeData(),
          ),
        ),
      ),
      designSize: const Size(410, 820),
    );
  }
}
