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
                        fontSize: phoneMode ? 40.sp : 40.sp,
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
                    child: SizedBox(
                      width: 200.sp,
                      height: 250.sp,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.sp),
                          side: BorderSide(
                              color: Colors.blue.withOpacity(.5), width: 5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: EdgeInsets.all(10.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                FlutterIcons.mail_ant,
                                color: Colors.blue,
                                size: 100.sp,
                              ),
                              Text(
                                'EMAIL',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'example@test.com',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(_createRoute2()),
                    child: SizedBox(
                      width: 200.sp,
                      height: 250.sp,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.sp),
                          side: BorderSide(
                              color: Colors.blue.withOpacity(.5), width: 5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: EdgeInsets.all(10.0.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                FlutterIcons.phone_ant,
                                color: Colors.blue,
                                size: 100.sp,
                              ),
                              Text(
                                'PHONE',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                'xxx-xxx-xxxx',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
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
