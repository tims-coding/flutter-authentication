import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ledger/services/auth.dart';
import 'package:flutter_ledger/services/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailRecovery extends StatefulWidget with EmailAndPasswordalidators {
  @override
  _EmailRecoveryState createState() => _EmailRecoveryState();
}

class _EmailRecoveryState extends State<EmailRecovery> {
  AuthService auth = AuthService();

  final TextEditingController _emailController = TextEditingController();
  String get _email => _emailController.text.trim();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          fontSize: 35.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: Material(
                      elevation: 8,
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: _emailController,
                          onChanged: (email) => _updateState(),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(FontAwesomeIcons.solidEnvelope),
                            labelText: 'Email',
                            hintText: 'test@test.com',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.sp),
                    child: Text(
                      'Enter your email and we will send you \n a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.sp, height: 1.5),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: RawMaterialButton(
                  onPressed: () {
                    auth.resetPassword(_email);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  elevation: 2.0,
                  fillColor: Colors.blue,
                  child: Icon(
                    FlutterIcons.arrow_forward_mdi,
                    size: phoneMode ? 40.sp : 70.0.sp,
                    color: Colors.white,
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
