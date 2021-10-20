import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ledger/services/auth.dart';
import 'package:flutter_ledger/shared/exception_alert_dialog.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordOTP extends StatefulWidget {
  final String phone;
  PasswordOTP(this.phone, {Key key}) : super(key: key);

  @override
  _PasswordOTPState createState() => _PasswordOTPState();
}

class _PasswordOTPState extends State<PasswordOTP> {
  String _verificationCode;

  AuthService auth = AuthService();

  final _pinPutController = TextEditingController();

  final _pinPutFocusNode = FocusNode();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(235, 236, 237, 1),
    borderRadius: BorderRadius.circular(10.0),
  );

  @override
  void initState() {
    super.initState();
    _verifyPhone();
    _pinPutFocusNode.requestFocus();
  }

  void _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+1${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              auth.resetPasswordPhone();
              String email = FirebaseAuth.instance.currentUser.email;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Successful'),
                  content: Text(
                      'A recovery email has been sent to $email. Please follow the link to reset your password.'),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () async {
                        await auth.signOut();
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          showExceptionAlertDialog(context, title: 'Failed', exception: e);
        },
        codeSent: (String verificationId, int resendToken) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 100.sp, left: phoneMode ? 10.sp : 50.sp),
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
                        'OTP Verification',
                        style: TextStyle(
                          fontSize: phoneMode ? 40.sp : 40.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100.sp),
                child: Icon(
                  FlutterIcons.phonelink_lock_mdi,
                  size: 150.sp,
                  color: Colors.blue,
                ),
              ),
              Text(widget.phone),
              Padding(
                padding: EdgeInsets.only(
                    left: phoneMode ? 10.sp : 75.sp,
                    right: phoneMode ? 10.sp : 75.sp,
                    top: 50.sp),
                child: PinPut(
                  fieldsCount: 6,
                  textStyle: TextStyle(fontSize: 35.sp, color: Colors.black),
                  eachFieldWidth: phoneMode ? 40.sp : 60.sp,
                  eachFieldHeight: phoneMode ? 50.sp : 75.sp,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: pinPutDecoration,
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.rotation,
                  onSubmit: (pin) async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        if (value.user != null) {
                          auth.resetPasswordPhone();
                          String email =
                              FirebaseAuth.instance.currentUser.email;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Successful'),
                              content: Text(
                                  'A recovery email has been sent to $email. Please follow the link to reset your password.'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    await auth.signOut();
                                    Navigator.pushReplacementNamed(
                                        context, '/');
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      showExceptionAlertDialog(context,
                          title: 'Verfifcation Failed', exception: e);
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'You have been sent a verification text. \n Your OTP code will be valid for 15 minutes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.white.withOpacity(.6),
                      height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
