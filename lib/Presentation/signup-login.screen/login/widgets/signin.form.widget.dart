import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Constants/constants.dart';
import 'package:pharmacy/GlobalWidgets/dialog.screen/alert.dialog.dart';
import 'package:pharmacy/Presentation/signup-login.screen/signup/main.signup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../homepage.screen/widgets/bottom.navigation.widget.dart';

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({super.key});
  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  // Let's declare some few variables...
  late bool _obscureText,
      _validateEmail,
      _validatePassword,
      _btnCircularProgress,
      _signInBtnCircularProgress;

  // Let's create a validator function to validate the inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // The signup function
  Future<void> login () async {
    var response;
    var requestBody = {
      "email": _emailController.text,
      "password": _passController.text,
    };

    try{
      response = await http.post(Uri.parse(LOGIN),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody)
      );
    }
    catch (error){
      print('ERROR CONNECTING TO SERVER: $error');
    }
    finally{
      if (response.statusCode == 200){
        // Convert the response into a list
        final Map<String, dynamic> jsonResponseBody = jsonDecode(response.body);

        //  Save the user id in the shared preferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('id', jsonResponseBody['id']);

        //  clear the controllers
        _emailController.clear();
        _passController.clear();
        setState(() {
          Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavigationWidget()));
          alertDialog();
        });
        print('THIS IS THE RESPONSE FROM THE SERVER: ${jsonResponseBody['id']}');
      } else {
        setState(() {
          _signInBtnCircularProgress = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Row(
                children: [
                  Text('Sorry, cannot sign in'),
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
        print('CANNOT LOGIN');
      }
    }
  }


  void validate(String email) {
    _validateEmail = EmailValidator.validate(email);
    // print(_validateEmail);
  }
  void validatePassword(String pass) {
    if (pass.isEmpty || pass.length < 5) {
      _validatePassword = false;
    } else {
      _validatePassword = true;
    }
    print(_validatePassword);
  }

  @override
  void initState() {
    _validateEmail = false;
    _validatePassword = false;
    _obscureText = true;
    _btnCircularProgress = false;
    _signInBtnCircularProgress = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController;
    _passController;
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
                          validate(_emailController.text);
                          if (_validateEmail == false) {
                            _validateEmail = true;
                          } else {
                            _validateEmail = false;
                          }

                          validatePassword(_passController.text);
                          if (_validatePassword == false) {
                            _validatePassword = true;
                          } else {
                            _validatePassword = false;
                          }

                          // Validate and proceed to the next screen...
                          if (_validateEmail == false && _validatePassword == false) {
                            setState(() {
                              _signInBtnCircularProgress = true;
                              login();
                            });
                          }
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
                        child: _signInBtnCircularProgress
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
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log in to continue from where you left from",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  )
                ]
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
                width: MediaQuery.of(context).size.width * .25,
                height: 1.0,
              ),
              const Text(
                'NO ACCOUNT?',
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w500,
                    fontSize: 22
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black
                ),
                width: MediaQuery.of(context).size.width * .25,
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainSignUpScreen()));
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
      ],
    );
  }

  Future alertDialog() async {
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            content: IntrinsicHeight(child: LogInAlertDialog(alertArgs: AlertArgs(head: 'Welcome Back!!!\n', body: 'Glad to have you back on the\nPharmCare App.!\n'),)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
            ),
          );
        }
    );
  }
}
