import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_ledger/screens/ForgotPassword/select_recovery.dart';
import 'package:flutter_ledger/services/auth.dart';
import 'package:flutter_ledger/shared/exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ledger/shared/shared_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_ledger/services/validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum EmailSignInFormType { signIn, register }

class LoginScreen extends StatefulWidget with EmailAndPasswordalidators {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text.trim();
  bool _submitted = false;
  bool _isHidden = true;
  bool signInType = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _passwordEditingComplete() {
    FocusScope.of(context).unfocus();
  }

  _submit() async {
    setState(() {
      _submitted = true;
    });
    try {
      await auth.signInEmailPassword(_email, _password);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
    auth.getUser.then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);
    bool emailValid = _submitted && !widget.emailValidator.isValid(_email);
    bool passwordValid =
        _submitted && !widget.passwordValidator.isValid(_password);
    final primaryText = 'Sign In';
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 70,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo-standard-dark.png', scale: 2.8),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      'Let\'s get Started ',
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Material(
                  elevation: 8,
                  color: Colors.grey[900],
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
                        errorText:
                            emailValid ? widget.invalidEmailErrorText : null,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Material(
                  elevation: 8,
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(FontAwesomeIcons.lock),
                          labelText: 'Password',
                          errorText: passwordValid
                              ? widget.invalidPasswordErrorText
                              : null,
                          suffix: InkWell(
                            onTap: _togglePassword,
                            child: Icon(
                              _isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.withOpacity(.7),
                              size: 20.sp,
                            ),
                          )),
                      obscureText: _isHidden,
                      onChanged: (password) => _updateState(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 35),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(_createRoute1());
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.blue[300],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: RoundedButton(
                        color: Colors.blue,
                        text: signInType ? "Sign In" : "Create an Account",
                        elevation: 3,
                        onTap: () {
                          if (submitEnabled == true) {
                            _submit();
                          }
                        }),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    signInType = !signInType;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      signInType
                          ? 'Need an Account? Register'
                          : 'Already Have an Account? Sign In',
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      width: 300,
                      child: GoogleButton(
                        onTap: () {},
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      width: 300,
                      child: AppleButton(
                        onTap: () {},
                      )),
                ],
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Image.asset(
                'assets/auth.png',
                scale: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  _updateState() {
    setState(() {});
  }
}

Route _createRoute1() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        SelectRecoveryProcess(),
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

class OTPverification extends StatefulWidget {
  final String email;
  final String password;
  final String phone;
  OTPverification(this.email, this.password, this.phone, {Key key})
      : super(key: key);
  @override
  _OTPverificationState createState() => _OTPverificationState();
}

class _OTPverificationState extends State<OTPverification> {
  AuthService auth = AuthService();

  String _verificationCode;

  bool phoneMode;

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
          await FirebaseAuth.instance.currentUser
              .linkWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushReplacementNamed(context, '/home');
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;
    if (x < 600) {
      setState(() {
        phoneMode = true;
      });
    } else {
      setState(() {
        phoneMode = false;
      });
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: y * .1, left: x * .065),
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
                    await FirebaseAuth.instance.currentUser
                        .linkWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
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
              padding: EdgeInsets.only(top: y * .02),
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
    );
  }
}
