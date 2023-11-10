import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AwarenessWidget extends StatefulWidget {
  const AwarenessWidget({super.key});

  @override
  State<AwarenessWidget> createState() => _AwarenessWidgetState();
}

class _AwarenessWidgetState extends State<AwarenessWidget> {
  List<Color> boxes = <Color>[
    const Color(0x2613CA87),
    const Color(0x26808000),
    const Color(0x26FF6F61),
    const Color(0x269900FF),
  ];

  late var initImage;
  @override
  void initState() {
    Random random = Random();
    setState(() {
      initImage = random.nextInt(4);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: awarenessItems.length,
      options: CarouselOptions(
        height: 150,
        aspectRatio: 16/9,
        viewportFraction: 0.95,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        // onPageChanged: onPageChanged,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int index, _){
        AwarenessArgs args = awarenessItems[index];
        return
          SizedBox(
            child: Container(
              decoration: BoxDecoration(
                  color: boxes[initImage],
                  borderRadius: BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Image(image: AssetImage(args.image)),
                    Expanded(
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          // color: Colors.green,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              args.heading,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 22.0,
                                color: Color(0xFF13CA87),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              args.body,
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
  List<AwarenessArgs> awarenessItems = <AwarenessArgs>[
    AwarenessArgs(image: 'assets/awareness/aidsesearch-cuate.png', heading: 'Have You Done Your HIV/AIDS Test?', body: 'Stay informed about your health. Schedule a test today and take control of your well-being.'),
    AwarenessArgs(image: 'assets/awareness/Christmas.png', heading: 'Celebrate Christmas with Joy!', body: 'Experience the magic of the season as you gather with loved ones, and create cherished memories. Merry Christmas, Happy New Year!'),
    AwarenessArgs(image: 'assets/awareness/foods-bro.png', heading: 'Stay healthy with a balanced diet!', body:'Include a variety of fruits, vegetables, and whole grains in your meals.'),
    AwarenessArgs(image: 'assets/awareness/announcement-bro.png', heading: 'Same Market! New Products!', body:'Stay informed about your health. Explore our new products designed to enhance your well-being.'),
  ];
}

class AwarenessArgs {
  String image;
  String heading;
  String body;

  AwarenessArgs ({
    required this.image,
    required this.heading,
    required this.body
  });
}
