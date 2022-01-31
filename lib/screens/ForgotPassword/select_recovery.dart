import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ledger/screens/ForgotPassword/email_recovery.dart';
import 'package:flutter_ledger/screens/ForgotPassword/phone_recovery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRecoveryProcess extends StatefulWidget {
  @override
  _SelectRecoveryProcessState createState() => _SelectRecoveryProcessState();
}

class _SelectRecoveryProcessState extends State<SelectRecoveryProcess> {
  bool phoneMode;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double x = MediaQuery.of(context).size.width;
    if (x < 600) {
      setState(() {
        phoneMode = true;
      });
    } else {
      setState(() {
        phoneMode = false;
      });
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 100.sp, left: phoneMode ? 10.sp : 50.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Icon(
                      FlutterIcons.ios_arrow_back_ion,
                      size: phoneMode ? 40.sp : 40.sp,
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40.sp),
                    child: Text(
                      'Select Recovery',
                      style: TextStyle(
                        fontSize: 35.sp,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 180.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(_createRoute()),
                    child: Material(
                      elevation: 8,
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: EdgeInsets.all(40.0.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              FlutterIcons.mail_ant,
                              color: Colors.blue,
                              size: 80.sp,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'EMAIL',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(_createRoute2()),
                    child: Material(
                      elevation: 8,
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: EdgeInsets.all(40.0.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              FlutterIcons.phone_ant,
                              color: Colors.blue,
                              size: 80.sp,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'PHONE',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => EmailRecovery(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createRoute2() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => PhoneRecovery(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
