import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/signup-login.screen/login/widgets/signin.form.widget.dart';
import 'package:pharmacy/Presentation/signup-login.screen/signup/widgets/signup.form.widget.dart';

class MainLoginScreen extends StatelessWidget {
  const MainLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F8FB),
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFF8F8FB),
      //   elevation: 0.0,
      //   toolbarHeight: 90.0,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(top: 15.0, right: 15.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.end,
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Text(
      //             'Already have an account?',
      //             style: TextStyle(
      //                 color: Color(0xFF000000),
      //                 fontWeight: FontWeight.w600,
      //                 fontSize: 22
      //             ),
      //           ),
      //           TextButton(
      //               onPressed: (){},
      //               child: const Text(
      //                 'Login',
      //                 style: TextStyle(
      //                   color: Colors.transparent,
      //                   fontWeight: FontWeight.w500,
      //                   fontSize: 22,
      //                   decoration: TextDecoration.underline,
      //                   decorationColor: Color(0xFFFF969c),
      //                   shadows: [Shadow(offset: Offset(0, -6), color: Color(0xFFFF969c))],
      //                 )
      //               )
      //           )
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Glad to see you again!,\n"
                              "Let's Get going...",
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                              fontSize: 38
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SignInFormWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
