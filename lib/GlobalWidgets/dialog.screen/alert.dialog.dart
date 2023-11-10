import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/bottom.navigation.widget.dart';
import '../../Presentation/signup-login.screen/signup/main.signup.dart';

class AlertArgs {
  String head;
  String body;
  AlertArgs({required this.head, required this.body});
}

class LogInAlertDialog extends StatefulWidget {
  const LogInAlertDialog({super.key, required this.alertArgs});
  final AlertArgs alertArgs;
  @override
  State<LogInAlertDialog> createState() => _LogInAlertDialogState();
}

class _LogInAlertDialogState extends State<LogInAlertDialog> {
  late bool _btnCircularProgress;

  @override
  void initState() {
    _btnCircularProgress = false;
    super.initState();
  }
  @override
  void dispose() {
    _btnCircularProgress;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0x2613CA87),
                  radius: 55,
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: Color(0xFF13CA87),
                    size: 55,
                  ),
                ),
                const SizedBox(height: 12.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: widget.alertArgs.head,
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                            ),
                          ),
                          TextSpan(
                            text: widget.alertArgs.body,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: Color(0xFFA1A8B0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // onTap function goes here...
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          backgroundColor: const Color(0xFF13CA87),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 4.0),
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
                            "Thank you",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }
}
