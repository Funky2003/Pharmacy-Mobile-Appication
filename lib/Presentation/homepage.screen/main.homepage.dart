import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pharmacy/Constants/constants.dart';
import 'package:pharmacy/GlobalWidgets/shimmer-effect.wdgets/shimmer.screen.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/awareness.widget.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/header.widget.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/more.products.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/new.products.widget.dart';
import 'package:http/http.dart' as http;
import 'package:pharmacy/Presentation/store.screen/main.store.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  // A FUNCTION TO GET ALL PRODUCTS...
  Future<List<dynamic>> getAllProducts() async {
    var response;
    try{
      response = await http.get(Uri.parse(GETPRODUCTS),
          headers: {"Content-Type": "application/json"}
      );
    }
    catch(error){
      print('THE FOLLOWING ERROR OCCURRED: $error');
    }
    finally{
      if (response.body != null && response.statusCode == 200){
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
    getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const HomepageHeader(),
          const Padding(
            padding: EdgeInsets.only(bottom: 18.0),
            child: AwarenessWidget(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'New products in store',
                  style: TextStyle(
                    color: Color(0xFF13CA87),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    // Set the color for the word 'Funky'
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MainStorePage()));
                  },
                  child: const Text(
                    'see all',
                    style: TextStyle(
                      color: Color(0xFF13CA87),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                future: getAllProducts(),
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return  Padding(
                      padding: EdgeInsets.all(16),
                      child: ShimmerEffects.homeShimmer(context: context),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData && snapshot.data != null){
                      final List<dynamic>? decodedJsonBody = snapshot.data;
                      print('ALL THE DATA FOUND IN THE PRODUCTS TABLE: ${decodedJsonBody?.toString()}');
                      return Row(
                        children: List.generate(decodedJsonBody!.take(5).length, (index) {
                          MedicineArgs args = MedicineArgs(
                              id: decodedJsonBody[index]['_id'],
                              image: decodedJsonBody[index]['image'],
                              price: decodedJsonBody[index]['price'].toString(),
                              name: decodedJsonBody[index]['name'],
                              stock: decodedJsonBody[index]['stockQuantity'].toString(),
                          );
                          return NewProducts(
                              medicineArgs: args
                          );
                        }),
                      );
                    }
                  } return  Padding(
                    padding: EdgeInsets.all(16),
                    child: ShimmerEffects.homeShimmer(context: context),
                  );;
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Daily and Basic essentials',
                  style: TextStyle(
                    color: Color(0xFF13CA87),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    // Set the color for the word 'Funky'
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x2613CA87),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 150,
                          height: 150,
                          child: Image(image: AssetImage('assets/awareness/Questions-pana.png'), fit: BoxFit.cover,)),
                      Container(
                          width: 200,
                          decoration: BoxDecoration(
                            // color: Colors.green,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'DO YOU KNOW?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22.0,
                                  color: Color(0xFF13CA87),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Breathing in and breathing out deeply in times of stress or regularly throughout the day boosts many surprising health benefits.',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const MoreProductsWidget()
        ]
      ),
    );
  }
}
