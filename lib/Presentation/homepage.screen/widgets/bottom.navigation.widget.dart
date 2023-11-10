import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/oders.screen/widgets/oders.main.dart';
import 'package:pharmacy/Presentation/profile.screen/widgets/main.user.profile.dart';
import 'package:pharmacy/Presentation/store.screen/main.store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../onboarding.screen/main.onboarding.dart';
import '../main.homepage.dart';


class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});
  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

late final MainCartItemsArgs mainCartItemsArgs = MainCartItemsArgs(
    image: 'assets/medicine/download1.jpg', price: '45', drug: 'Modafinil', quantity: 0
);

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  // Let's create a function to control the flow of the pages...
  var index = 0;
  void pageIndex(itmIndex){
    setState(() {
      index = itmIndex;
    });
  }


  List<Widget> navigationPages = [
    const HomePageScreen(),
    const MainStorePage(),
    MainOrdersPage(mainCartItemsArgs: mainCartItemsArgs,),
    const MainUserProfile(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var popDuration;
    return Scaffold(
      body: WillPopScope( //The I'm using the onPopScope to prevent accidental close of the app...
          onWillPop: (){
            var popTime = DateTime.now();
            if (popDuration == null || popTime.difference(popDuration) > Duration(seconds: 2)){
                popDuration = popTime;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Text('Press back again to close app...'),
                      Spacer(),
                      Icon(
                        CupertinoIcons.info_circle,
                        color: CupertinoColors.destructiveRed,
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Center(
            child: navigationPages[index],
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: pageIndex,
          iconSize: 26.0,
          selectedItemColor: const Color(0xFF13CA87),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold
          ),
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                    CupertinoIcons.home,
                    color: Colors.black54
                ),
                label: 'Home',
              activeIcon: Icon(
                CupertinoIcons.house_fill,
                  color: Color(0xFF13CA87)
            ),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                  CupertinoIcons.bag,
                  color: Colors.black54
              ),
              label: 'Store',
              activeIcon: Icon(
                  CupertinoIcons.bag_fill,
                  color: Color(0xFF13CA87)
              ),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                  CupertinoIcons.cart,
                  color: Colors.black54
              ),
              label: 'Orders',
              activeIcon: Icon(
                  CupertinoIcons.cart_fill,
                  color: Color(0xFF13CA87)
              ),
            ),

            BottomNavigationBarItem(
              icon: Icon(
                  CupertinoIcons.ellipsis_circle,
                  color: Colors.black54
              ),
              label: 'More',
              activeIcon: Icon(
                  CupertinoIcons.ellipsis_circle_fill,
                  color: Color(0xFF13CA87)
              ),
            )
          ],
      ),
    );
  }
}
