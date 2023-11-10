import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageHeader extends StatefulWidget {
  const HomepageHeader({super.key});
  @override
  State<HomepageHeader> createState() => _HomepageHeaderState();
}

class _HomepageHeaderState extends State<HomepageHeader> with TickerProviderStateMixin {
  // a function to do greetings...
  late String cTime;
  void currentTime (){
    var hour = DateTime.now().hour;
    if (hour >= 5  && hour < 11.99){
      setState(() {
        cTime = "Morning";
      });
    } else if (hour >= 11.99 && hour < 17.99){
      setState(() {
        cTime = "Afternoon";
      });
    } else if (hour >= 17.99){
      setState(() {
        cTime = "Evening";
      });
    } else {
      setState(() {
        cTime = "Night";
      });
    }
  }

  // the animating bell icon and notification...
  late AnimationController _bellIconController;
  bool notification = true;

  @override
  void initState() {
    _bellIconController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _bellIconController.repeat();
    currentTime();
    super.initState();
  }

  @override
  void dispose() {
    _bellIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                  // color: Colors.blue,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * .55
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24.0,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black, // Set the default color for the text
                      ),
                      children: [
                        TextSpan(
                          text: 'Good $cTime, ',
                        ),
                        const TextSpan(
                          text: 'Funky...',
                          style: TextStyle(
                            color: Color(0xFF13CA87),
                            fontSize: 28.0,
                            // Set the color for the word 'Funky'
                          ),
                        ),
                        const TextSpan(
                          text: '!',
                        ),
                      ],
                    ),
                  ),

                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: (){
                              if (_bellIconController.isAnimating) {
                                // _bellIconController.stop();
                                _bellIconController.reset();
                                setState(() {
                                  notification = false;
                                });
                              } else {
                                setState(() {
                                  notification = true;
                                });
                                _bellIconController.repeat();
                              }
                            },
                            splashRadius: 20.0,
                            // LET'S CREATE A LOTTIE NOTIFICATION ICON...
                            icon: Lottie.asset(
                              notification? LottieFiles.$63128_bell_icon : LottieFiles.$33262_icons_bell_notification,
                              controller: _bellIconController,
                            )
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          showFabDialog();
                        });
                      },
                      radius: 100.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF13CA87), width: 1.5),
                            borderRadius: BorderRadius.circular(100.0)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            maxRadius: 16.0,
                            child: CachedNetworkImage(
                                width: MediaQuery.of(context).size.width * 1,
                                placeholder: (context, url) => const CircularProgressIndicator(color: Colors.grey),
                                errorWidget: (context, url, error) => const Icon(CupertinoIcons.wand_stars_inverse, size: 15.0, color: Colors.red,),
                                imageUrl: 'https://batmubdfrlbcaniaaxrr.supabase.co/storage/v1/object/public/images/avatars/2023-10-31T08:56:45.945365.jpg', fit: BoxFit.cover
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showFabDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
              content: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .5
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                          onPressed: () async {
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            setState(() {
                              preferences.clear();
                              Navigator.pushReplacementNamed(context, 'login');
                            });
                          },
                          color: CupertinoColors.systemRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)
                          ),
                          child: const Text(
                            'Sign out',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          )
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}
