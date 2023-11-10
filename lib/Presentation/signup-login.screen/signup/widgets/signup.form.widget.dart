import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Constants/constants.dart';
import 'package:pharmacy/Presentation/signup-login.screen/login/main.login.dart';
import '../../../../GlobalWidgets/dialog.screen/alert.dialog.dart';
import 'package:http/http.dart' as http;

import '../../../homepage.screen/widgets/bottom.navigation.widget.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});
  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  // Let's declare some few variables...
  late bool _obscureText,
      _validateEmail,
      _validatePassword,
      _validateName,
      _validateAddress,
      _btnCircularProgress,
      _signupBtnCircularProgress;

  // Let's create a validator function to validate the inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _nameValidator(String name) {
    if (name.isEmpty) {
      _validateName = false;
    } else {
      _validateName = true;
    }
  } //Validate name
  void _addressValidator(String name) {
    if (name.isEmpty) {
      _validateAddress = false;
    } else {
      _validateAddress = true;
    }
  } //Validate address
  void validate(String email) {
    _validateEmail = EmailValidator.validate(email);
    // print(_validateEmail);
  } //Validate email
  void validatePassword(String pass) {
    if (pass.isEmpty || pass.length < 5) {
      _validatePassword = false;
    } else {
      _validatePassword = true;
    }
    print(_validatePassword);
  } //Validate password

  // The signup function
  Future<void> signup () async {
    var response;
    var requestBody = {
      "email": _emailController.text,
      "password": _passController.text,
      "name": _nameController.text,
      "address": _addressController.text
    };

    try{
      response = await http.post(Uri.parse(SIGNUP),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody)
      );
    }
    catch (error){
      print('ERROR CONNECTING TO SERVER: $error');
    }
    finally{
      // Convert the response into a list
      final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);

      //  Save the user id in the shared preferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('id', jsonResponseBody['id']);

      if (response.statusCode == 201){
        _emailController.clear();
        _nameController.clear();
        _passController.clear();
        _addressController.clear();
        setState(() {
          Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationWidget()));
          alertDialog();
        });
        print('THIS IS THE RESPONSE FROM THE SERVER: ${jsonDecode(response.body['email'])}');
      } else {
        setState(() {
          _signupBtnCircularProgress = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Row(
              children: [
                Text('Sorry, we are unable to create your account'),
                Spacer(),
                Icon(
                  CupertinoIcons.info_circle,
                  color: CupertinoColors.destructiveRed,
                )
              ],
            ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              behavior: SnackBarBehavior.floating,
            )
          );
        });
        print('ACCOUNT COULD NOT BE CREATED');
      }
    }
  }

  @override
  void initState() {
    _validateEmail = false;
    _validatePassword = false;
    _validateName = false;
    _validateAddress = false;
    _obscureText = true;
    _btnCircularProgress = false;
    _signupBtnCircularProgress = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController;
    _passController;
    _nameController;
    _addressController;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    expands: false,
                    maxLines: 1,
                    controller: _nameController,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Image(image: AssetImage('assets/icons/icon-park_edit-name.png')),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xFF13CA87), width: 1.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      label: _validateName
                          ? const Text(
                        'Incorrect name',
                        style: TextStyle(
                            fontFamily: 'Mooli', color: Colors.red),
                      )
                          : const Text("Enter you full name"),
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13CA87),),
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 22),
                  child: TextFormField(
                    expands: false,
                    keyboardType: TextInputType.emailAddress,
                    maxLines: 1,
                    controller: _emailController,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Image(image: AssetImage('assets/icons/ic_twotone-email.png')),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF13CA87),
                              width: 1.0),
                          borderRadius:
                          BorderRadius.circular(25.0)),
                      label: _validateEmail
                          ? const Text(
                        'Incorrect email',
                        style: TextStyle(
                            fontFamily: 'Mooli',
                            color: Colors.red),
                      )
                          : const Text("Enter email"),
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xFF13CA87)),
                          borderRadius:
                          BorderRadius.circular(25.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    expands: false,
                    maxLines: 1,
                    controller: _addressController,
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Image(image: AssetImage('assets/icons/Location.png')),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xFF13CA87), width: 1.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      label: _validateAddress
                          ? const Text(
                        'Incorrect address',
                        style: TextStyle(
                            fontFamily: 'Mooli', color: Colors.red),
                      )
                          : const Text("Enter you address"),
                      labelStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF13CA87),),
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12)), // For vertical spacing
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        expands: false,
                        maxLines: 1,
                        controller: _passController,
                        obscureText: _obscureText,
                        cursorColor: Colors.black,
                        cursorWidth: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(right: 2.0),
                            child: Image(image: AssetImage('assets/icons/bx_lock-alt.png')),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF13CA87),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          suffixIconColor: Colors.black54,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            icon: Icon(_obscureText
                                ? CupertinoIcons.eye_slash
                                : Icons.visibility),
                          ),
                          label: _validatePassword
                              ? const Text(
                            'Incorrect password',
                            style: TextStyle(
                              fontFamily: 'Mooli',
                              color: Colors.red,
                            ),
                          )
                              : const Text("Your password"),
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF13CA87),
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 15,
                    child: ElevatedButton(
                      onPressed: () {
                        // onTap function goes here...
                        setState(() {
                          //Validate Name
                          _nameValidator(_nameController.text);
                          if (_validateName == false) {
                            _validateName = true;
                          } else {
                            _validateName = false;
                          }
                          //Validate Address
                          _addressValidator(_addressController.text);
                          if (_validateAddress == false) {
                            _validateAddress = true;
                          } else {
                            _validateAddress = false;
                          }

                          //Validate Eamil
                          validate(_emailController.text);
                          if (_validateEmail == false) {
                            _validateEmail = true;
                          } else {
                            _validateEmail = false;
                          }

                          //Validate Password
                          validatePassword(_passController.text);
                          if (_validatePassword == false) {
                            _validatePassword = true;
                          } else {
                            _validatePassword = false;
                          }

                          // Validate and proceed to the next screen...
                          if (_validateName == false && _validateAddress == false && _validateEmail == false && _validatePassword == false) {
                            setState(() {
                              _signupBtnCircularProgress = true;
                              signup();
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(25.0)),
                          backgroundColor: Color(0xFF13CA87)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: _signupBtnCircularProgress
                            ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "Sign up",
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 22
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'By signing up, I’ve read and agree to our ',
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Color(0xFFFF969c),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: ' and ',
                        ),
                        TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(
                            color: Color(0xFFFF969c),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
                width: MediaQuery.of(context).size.width * .40,
                height: 1.0,
              ),
              const Text(
                'OR',
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w500,
                    fontSize: 28
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
                width: MediaQuery.of(context).size.width * .40,
                height: 1.0,
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 15,
              child: ElevatedButton(
                onPressed: () {
                  // onTap function goes here...
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLoginScreen()));
                  });
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(25.0)),
                    backgroundColor: Colors.black
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _btnCircularProgress
                      ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Log in",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w600,
                        fontSize: 22
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  Future alertDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            content: IntrinsicHeight(child: LogInAlertDialog(alertArgs: AlertArgs(head: 'Hurrayyy!!!\n', body: 'You are officially part of PharmCare.!\n'),)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            ),
          );
        }
    );
  }
}
