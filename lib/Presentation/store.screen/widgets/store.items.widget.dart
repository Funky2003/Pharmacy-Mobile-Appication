import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Constants/constants.dart';
import '../../../GlobalWidgets/shimmer-effect.wdgets/shimmer.screen.dart';
import '../../drug-detail.screen/main.details.screen.dart';
import '../../homepage.screen/widgets/more.products.dart';
import 'package:http/http.dart' as http;

class StoreWidget extends StatefulWidget {
  const StoreWidget({super.key});

  @override
  State<StoreWidget> createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> {
  // Let's create a search function to filter the hostels based on the search input...
  TextEditingController searchController = TextEditingController();
  // List<MoreProductsWidget> filteredHostels (String search){
  //   return .where((hostel) {
  //     final name = hostel.hostelName.toLowerCase();
  //     final location = hostel.hostelLocation.toLowerCase();
  //     final address = hostel.hostelAddress.toLowerCase();
  //     return name.contains(search) || location.contains(search) || address.contains(search);
  //   }).toList();
  // }

  Future<List<dynamic>> getAllProducts() async {
    var response;
    try {
      response = await http.get(Uri.parse(GETPRODUCTS),
          headers: {"Content-Type": "application/json"});
    } catch (error) {
      print('THE FOLLOWING ERROR OCCURRED: $error');
    } finally {
      if (response.body != null && response.statusCode == 200) {
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemCount: 50,
                      itemBuilder: (BuildContext context, index) {
                        return ShimmerEffects.homeShimmer(context: context);
                      }),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData && snapshot.data != null) {
                  final List<dynamic>? decodedJsonBody = snapshot.data;
                  print('ALL THE DATA FOUND IN THE PRODUCTS TABLE: ${decodedJsonBody?.toString()}');
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 4.3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                        itemCount: decodedJsonBody!.length,
                        itemBuilder: (BuildContext context, index) {
                          MoreProductsArgs moreProductsArgs = MoreProductsArgs(
                            image: decodedJsonBody[index]['image'],
                            name: decodedJsonBody[index]['name'],
                            price: decodedJsonBody[index]['price'].toString(),
                          );
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainDrugDetailScreen(
                                          mainDrugDetailScreenArgs:
                                          MainDrugDetailScreenArgs(
                                            id: decodedJsonBody[index]['_id'],
                                            image: decodedJsonBody[index]['image'],
                                            drug: decodedJsonBody[index]['name'],
                                            price: decodedJsonBody[index]['price'].toString(),
                                            stock: decodedJsonBody[index]['stockQuantity'].toString(),
                                          ))));
                            },
                            child: Card(
                              color: const Color(0x2513CA87),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              child: SizedBox(
                                                  height: 150,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Image(
                                                      image: NetworkImage(
                                                          moreProductsArgs.image),
                                                      fit: BoxFit.cover)))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            moreProductsArgs.name,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            'GHC${moreProductsArgs.price}',
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(5.0),
                                                    color: const Color(0xFF13CA87)),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.0, vertical: 1),
                                                  child: Text(
                                                    'Add to cart',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              const InkWell(
                                                child: Icon(
                                                  CupertinoIcons.add_circled,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                } else {
                  return const Text('NO DATA FOUND');
                }
              }
              return const Text('');
            }),
      ),
    );
  }

  // Let's create a filter dialog to help users do the item filtering...
  Future<void> filterDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .5
                ),
                child: Text('Comming soon...'),
              )
          );
        }
    );
  }
}
