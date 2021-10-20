import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionButton extends StatelessWidget {
  final String transaction;
  final Color color;
  final Function onTap;
  TransactionButton({this.transaction, this.color, this.onTap});

  bool phoneMode;

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.width;
    if (x < 600) {
      phoneMode = true;
    } else {
      phoneMode = false;
    }
    return InkWell(
      onTap: () {
        onTap;
      },
      child: SizedBox(
        height: 60.h,
        child: Card(
          color: color.withOpacity(.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(y * .003),
            side: BorderSide(color: Colors.orange, width: y * .005),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(x * .0065),
                child: Text(
                  transaction,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: phoneMode ? 13 : 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  @required
  final String text;
  @required
  final Color color;
  @required
  final Function onTap;
  @required
  final double elevation;
  RoundedButton({this.text, this.color, this.onTap, this.elevation});

  bool phoneMode;

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    if (x < 600) {
      phoneMode = true;
    } else {
      phoneMode = false;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color.withOpacity(.5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Material(
              borderRadius: BorderRadius.circular(50),
              color: color,
              elevation: elevation,
              child: Center(
                  child: Text(
                text,
                style: GoogleFonts.poppins(),
              ))),
        ),
      ),
    );
  }
}

class GoogleButton extends StatelessWidget {
  @required
  final Function onTap;
  GoogleButton({this.onTap});

  bool phoneMode;

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    if (x < 600) {
      phoneMode = true;
    } else {
      phoneMode = false;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white.withOpacity(.5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Material(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              elevation: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterIcons.google_zoc,
                    color: Colors.red,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Sign In With Google",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class AppleButton extends StatelessWidget {
  @required
  final Function onTap;
  AppleButton({this.onTap});

  bool phoneMode;

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    if (x < 600) {
      phoneMode = true;
    } else {
      phoneMode = false;
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black.withOpacity(.5)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: InkWell(
          onTap: onTap,
          child: Material(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black,
              elevation: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    FlutterIcons.apple_mco,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Sign In With Apple",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  @required
  final String text;
  @required
  final Color color;
  @required
  final Function onTap;
  @required
  final double elevation;
  @required
  final double height;
  @required
  final double width;
  @required
  final double padding;
  @required
  final double borderRadius;

  SquareButton(
      {this.text,
      this.color,
      this.onTap,
      this.elevation,
      this.height,
      this.width,
      this.padding,
      this.borderRadius});

  bool phoneMode;

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    if (x < 600) {
      phoneMode = true;
    } else {
      phoneMode = false;
    }
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: color.withOpacity(.5)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: InkWell(
          onTap: () {
            onTap;
          },
          child: Material(
            borderRadius: BorderRadius.circular(borderRadius),
            color: color,
            elevation: elevation,
            child: Center(
                child: Text(
              text,
              style: GoogleFonts.poppins(),
            )),
          ),
        ),
      ),
    );
  }
}
