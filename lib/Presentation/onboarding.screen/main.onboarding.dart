import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pharmacy/Presentation/signup-login.screen/login/main.login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainOnboardingScreen extends StatefulWidget {
  const MainOnboardingScreen({super.key});

  @override
  State<MainOnboardingScreen> createState() => _MainOnboardingScreenState();
}

class _MainOnboardingScreenState extends State<MainOnboardingScreen> {
  bool onboarded = false;

  Future<void> checkOnBoard() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? onboard = preferences.getBool('onboarded');
    if (onboard == true){
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLoginScreen()));
      });
    }
  }

  @override
  void initState() {
    checkOnBoard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IntroductionScreen(
          pages: pageViewModel,
          done: const Text(
            'Done',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18
            ),
          ),
          onDone: () async{
            onboarded = true;
            SharedPreferences preferences = await SharedPreferences.getInstance();
            setState(() {
              preferences.setBool('onboarded', onboarded);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLoginScreen()));
            });
          },
          skip: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: CupertinoColors.systemGreen,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            ),
          ),
          showNextButton: true,
          showSkipButton: true,
          skipStyle: TextButton.styleFrom(
            side: const BorderSide(
              width: 1.5,
              color: CupertinoColors.systemGreen
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
            )
          ),
          doneStyle: TextButton.styleFrom(
              side: const BorderSide(
                  width: 1.5,
                  color: CupertinoColors.systemGreen
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
              ),
          ),
          next: IconButton(
            onPressed: (){},
            icon: const Icon(
              CupertinoIcons.arrow_right,
              color: Colors.black,
              size: 25,
          )),
        ),
      ),
    );
  }

  List<PageViewModel> pageViewModel = <PageViewModel>[
    PageViewModel(
        titleWidget: const Text(
            'On prescriptions...?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35.0
            ),
        ),
        image: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/onboarding/Medical prescription-bro.png')),
        ),
      decoration: const PageDecoration(
        pageMargin: EdgeInsets.symmetric(vertical: 25.0),
      ),
      bodyWidget: const Column(
        children: [
          Text(
              'You don’t need to go through the stress of going to a pharmacy to get drugs',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 22.0
            ),
            textAlign: TextAlign.center,
          )
        ],
      )
    ),

    PageViewModel(
        titleWidget: const Text(
          "Can't make it to the pharmacy...?",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35.0
          ),
        ),
        image: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/onboarding/Medicine-5.png')),
        ),
        decoration: const PageDecoration(
            pageMargin: EdgeInsets.symmetric(vertical: 25.0)
        ),
        bodyWidget: const Column(
          children: [
            Text(
              'There is no need going to the pharmacy to buy your prescribed drugs.'
              'Relax, Submit your order'
              'And the drugs will be delivered at your door step...SIMPLE!',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22.0
              ),
              textAlign: TextAlign.start,
            )
          ],
        )
    ),

    PageViewModel(
        titleWidget: const Text(
          'Love what you read...?',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 35.0
          ),
        ),
        image: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Image(image: AssetImage('assets/onboarding/Pharmacist-1.png')),
        ),
        decoration: const PageDecoration(
          pageMargin: EdgeInsets.symmetric(vertical: 25.0),
        ),
        bodyWidget: const Column(
          children: [
            Text(
              "Lay in your bed, send your requests and let our nurse do the magic for you!",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22.0
              ),
              textAlign: TextAlign.center,
            )
          ],
        )
    ),
  ];
}
