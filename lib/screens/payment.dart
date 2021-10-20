import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_ledger/screens/login.dart';
import 'package:flutter_ledger/services/db.dart';
import 'package:flutter_ledger/services/models.dart';
import 'package:flutter_ledger/shared/exception_alert_dialog.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_ledger/services/auth.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class Pricing {
  String paymentType;
  int price;
  int id;

  Pricing({this.paymentType, this.price, this.id});
}

class _PaymentScreenState extends State<PaymentScreen> {
  /// Backed Uri
  ///
  final Uri backendBaseUri = Uri.parse(
      "https://qy41bomyhf.execute-api.us-east-2.amazonaws.com/default/ledger-payments-options");
  final Uri backendBaseUriCardPayment = Uri.parse(
      "https://qy41bomyhf.execute-api.us-east-2.amazonaws.com/default/attempt-charge");

  /// AuthBase for Firbase User info
  ///
  AuthService auth = AuthService();

  /// TextControllers
  ///
  final TextEditingController _nameGameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '(000) 000 0000');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  /// Focus Nodes
  ///
  final FocusNode _nameGameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();

  /// Get text
  ///
  String get _nameGame => _nameGameController.text;
  String get _email => _emailController.text.trim();
  String get _phone => _phoneController.text.trim();
  String get _password => _passwordController.text.trim();
  String get _confirmPassword => _confirmPasswordController.text.trim();

  /// Password text hidden bool
  bool _isHidden = true;

  /// Required error bool
  bool _isRequired = false;

  /// create email bool
  bool createEmailPasswordError = false;

  /// Create User Functions
  ///
  _submit() {
    /// Create Email and Password in Firebase
    if (createEmailPasswordError == false) {
      /// create path to game stats
      final Document<Game> game =
          Document<Game>(path: '$_nameGame/data/game/stats');

      /// set game values to zero
      game.upsert(
        ({
          'gameSwitch': false,
          'cashOH': 0,
          'chipsOH': 0,
          'ecashOH': 0,
          'donation': 0,
          'tax': 0,
          'expenses': 0,
        }),
      );

      /// create a subscription status
      final Document<Game> subscription =
          Document<Game>(path: '$_nameGame/data/subscription/paymentStatus');

      subscription.upsert(
        ({
          'status': true,
        }),
      );

      /// naviaget user to homepage or otp verification if phone was used
      auth.getUser.then((user) {
        if (user != null) {
          if (_phone.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OTPverification(
                        _email,
                        _password,
                        _phone
                            .replaceAll('(', '')
                            .replaceAll(')', '')
                            .replaceAll(' ', ''))));
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      });
    }
  }

  Future<void> createAccount() async {
    try {
      await auth.createUserEmailPassword(_email, _password);
    } on FirebaseAuthException catch (e) {
      setState(() {
        createEmailPasswordError = true;
      });
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  @override
  void dispose() {
    _nameGameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameGameNode.dispose();
    _emailNode.dispose();
    _phoneNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Register"),
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40)),
                            color: Colors.blue[300]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ListTile(
                              title: TextField(
                                controller: _nameGameController,
                                focusNode: _nameGameNode,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.gamepad),
                                  labelText: 'game name\*',
                                  errorText: _isRequired ? 'Required' : null,
                                ),
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_emailNode),
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: TextField(
                                controller: _emailController,
                                focusNode: _emailNode,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  labelText: 'email\*',
                                  errorText: _isRequired ? 'Required' : null,
                                ),
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_phoneNode),
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: TextField(
                                controller: _phoneController,
                                focusNode: _phoneNode,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  labelText: 'phone',
                                  errorText: _isRequired ? 'Required' : null,
                                ),
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_passwordNode),
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: TextField(
                                controller: _passwordController,
                                focusNode: _passwordNode,
                                obscureText: _isHidden,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock),
                                    labelText: 'password\*',
                                    errorText: _isRequired ? 'Required' : null,
                                    suffix: InkWell(
                                      onTap: _togglePassword,
                                      child: Icon(
                                        _isHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white.withOpacity(.7),
                                      ),
                                    )),
                                onEditingComplete: () => FocusScope.of(context)
                                    .requestFocus(_confirmPasswordNode),
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListTile(
                              title: TextField(
                                controller: _confirmPasswordController,
                                focusNode: _confirmPasswordNode,
                                obscureText: _isHidden,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.lock),
                                    labelText: 'confirm password\*',
                                    errorText: _isRequired ? 'Required' : null,
                                    suffix: InkWell(
                                      onTap: _togglePassword,
                                      child: Icon(
                                        _isHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white.withOpacity(.7),
                                      ),
                                    )),
                                onEditingComplete: () =>
                                    FocusScope.of(context).unfocus(),
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: eventuallyBuildPaymentList(),
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  /// Build Payment List Options
  ///
  Widget buildStaticPaymentList(List<Pricing> payments) {
    return ListView(
      children: payments.map(buildPaymentItem).toList(),
    );
  }

  Widget buildPaymentItem(Pricing payment) {
    return ListTile(
      title: Text(
        payment.paymentType,
        style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
      ),
      subtitle: Text(
        "id: uuid${payment.id}",
        style: GoogleFonts.poppins(fontSize: 10),
      ),
      trailing: SizedBox(
        width: 150,
        child: ElevatedButton(
            onPressed: () {
              if (_nameGame.isNotEmpty &
                  _email.isNotEmpty &
                  _password.isNotEmpty &
                  _confirmPassword.isNotEmpty &
                  (_password == _confirmPassword)) {
                handlePayemntTap(payment);
              } else {
                _isRequired = true;
              }
            },
            child: Text("\$" + payment.price.toString())),
      ),
    );
  }

  Widget maybeBuildPaymentList(
      BuildContext context, AsyncSnapshot<Widget> snapshot) {
    if (snapshot.hasData) {
      return snapshot.data;
    } else {
      return Text('Loading...');
    }
  }

  Widget eventuallyBuildPaymentList() {
    return FutureBuilder<Widget>(
      future: loadingPaymentList(),
      builder: maybeBuildPaymentList,
    );
  }

  /// Load Lists
  ///
  Future<Widget> loadingPaymentList() async {
    var response = await http.get(backendBaseUri);
    var paymentData = jsonDecode(response.body);
    var payments = List<Map<String, Object>>.from(paymentData['payments'])
        .map((entry) => Pricing(
            paymentType: entry["name"],
            price: entry["amount"],
            id: entry["id"]))
        .toList();
    return buildStaticPaymentList(payments);
  }

  /// Handle Price Selection
  ///
  handlePayemntTap(Pricing chosenOption) async {
    await createAccount();
    if (createEmailPasswordError == false) {
      InAppPayments.setSquareApplicationId(
          'sandbox-sq0idb-X5zDYGIJ1NRV5PKvWGHOSA');
      InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (cardDetails) =>
            _handleCardNonceRequestSuccess(cardDetails, chosenOption),
        onCardEntryCancel: _handleCardEntryCancel,
      );
    }
  }

  /// Handle Card Request
  ///
  void _handleCardNonceRequestSuccess(
      CardDetails cardDetails, Pricing chosenOption) async {
    var body =
        jsonEncode({'nonce': cardDetails.nonce, 'paymentId': chosenOption.id});
    var response = await http.post(backendBaseUriCardPayment, body: body);
    print("     LOOOK LOOK LOOK LOOK   ${response.body}");
    if (response.statusCode == 200) {
      InAppPayments.completeCardEntry(
          onCardEntryComplete: () => _cardEntryComplete(response));
    } else {
      InAppPayments.showCardNonceProcessingError(
          "Charge Failed + ${response.body}");
    }
  }

  void _cardEntryComplete(http.Response response) async {
    await _submit();
    var responseBody = jsonDecode(response.body);
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Icon(
              Icons.check_circle_outline,
              color: Colors.greenAccent,
              size: 60,
            ),
            content: Center(
                child: Text(
                    "Successfully received ${responseBody["paymentName"]}"))));
  }

  /// Cancel Card Entry
  ///
  void _handleCardEntryCancel() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Icon(
                FlutterIcons.times_faw5s,
                size: 60,
                color: Colors.redAccent,
              ),
              content: Center(child: Text("Card Entry Canceled")),
            ));
  }

  void _togglePassword() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
