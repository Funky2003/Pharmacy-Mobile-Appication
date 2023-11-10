import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Constants/constants.dart';
import 'package:http/http.dart' as http;

class ApprovalWidget extends StatefulWidget {
  const ApprovalWidget({super.key});

  @override
  State<ApprovalWidget> createState() => _SettingOptionsState();
}

class _SettingOptionsState extends State<ApprovalWidget> {
  Future<List<dynamic>> getAllOrders() async {
    var response;
    try {
      response = await http.get(Uri.parse(GETORDERS),
          headers: {"Content-Type": "application/json"});
    } catch (error) {
      print('THE FOLLOWING ERROR OCCURRED: $error');
    } finally {
      if (response.body != null) {
        List<dynamic> decodedJsonBody = jsonDecode(response.body);
        return decodedJsonBody;
      } else {
        print('NO DATA FOUND IN THE PRODUCTS TABLE');
        return [];
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: SizedBox(
          child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: const Color(0xFFE8F3F1),
                    width: 1
                )
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100,child: ClipRRect(borderRadius: BorderRadius.circular(15.0),child: Image(image: AssetImage('assets/medicine/download.jpg'), fit: BoxFit.cover,))),
                  Column(
                    children: [
                      Text(
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                          ),
                      ),

                      const Text(
                        'Approved',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color:  Color(0xFF13CA87)
                        ),
                      )
                    ],
                  ),
                  MaterialButton(
                    color: CupertinoColors.systemBlue,
                    onPressed: (){},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: const Text(
                        'View',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
