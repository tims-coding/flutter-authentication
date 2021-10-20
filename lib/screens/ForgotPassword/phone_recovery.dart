import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ledger/screens/ForgotPassword/password_otp.dart';
import 'package:flutter_ledger/services/auth.dart';
import 'package:flutter_ledger/services/validators.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneRecovery extends StatefulWidget with EmailAndPasswordalidators {
  @override
  _PhoneRecoveryState createState() => _PhoneRecoveryState();
}

class _PhoneRecoveryState extends State<PhoneRecovery> {
  AuthService auth = AuthService();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '(000) 000 0000');
  String get _phone => _phoneController.text
      .trim()
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll(' ', '');

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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: phoneMode ? 40.sp : 40.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    right: phoneMode ? 20.sp : 100.sp,
                    left: phoneMode ? 20.sp : 100.sp,
                    top: 200.sp),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(20.sp)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0.sp),
                  child: TextField(
                    style: TextStyle(fontSize: 30.sp),
                    controller: _phoneController,
                    onChanged: (phone) => _updateState(),
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.phone,
                        size: 45.sp,
                      ),
                      labelText: 'Phone',
                      hintText: 'xxxxxxxxxx',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.sp),
                child: Text(
                  'Enter your phone number and we will send you \n a verification code to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.white.withOpacity(.6),
                      height: 1.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: phoneMode ? 100.sp : 140.sp),
                child: RawMaterialButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordOTP(_phone))),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  child: Icon(
                    FlutterIcons.arrow_forward_mdi,
                    size: phoneMode ? 40.sp : 70.0.sp,
                    color: Colors.blue,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
