import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/GlobalWidgets/SnackBar/snack-bar.dart';
import 'package:pharmacy/SharedPreferences/shared-prefences.dart';

import '../../drug-detail.screen/main.details.screen.dart';

class MedicineArgs {
  String id;
  String image;
  String name;
  String price;
  String stock;
  MedicineArgs({required this.image, required this.price, required this.name, required this.stock, required this.id});
}

class NewProducts extends StatefulWidget {
  const NewProducts({super.key, required this.medicineArgs});
  final MedicineArgs medicineArgs;
  @override
  State<NewProducts> createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Color(0x2613CA87),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        // Inkwell onTap Function goes here...
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            MainDrugDetailScreen(
                                mainDrugDetailScreenArgs:
                                MainDrugDetailScreenArgs(
                                    id: widget.medicineArgs.id,
                                    image: widget.medicineArgs.image,
                                    drug: widget.medicineArgs.name,
                                    price: widget.medicineArgs.price,
                                    stock: widget.medicineArgs.stock,
                                ))));
                      });
                    },
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * .25,
                          maxWidth: MediaQuery.of(context).size.width * .50,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.green,
                            image: DecorationImage(image: NetworkImage(widget.medicineArgs.image), fit: BoxFit.cover)
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Card(
                                    color: Colors.white,
                                    elevation: 9.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100.0)
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        SharedPrefs().saveData(
                                            id: widget.medicineArgs.id,
                                            name: widget.medicineArgs.name,
                                            image: widget.medicineArgs.image,
                                            price: widget.medicineArgs.price,
                                            stock: widget.medicineArgs.stock,
                                            quantity: 1.toString(),
                                        );

                                        setState(() {
                                          MySnackBar().mySnackBar(
                                              context,
                                              'Item added to cart?',
                                              const Color(0xFF13CA87),
                                              CupertinoIcons.check_mark
                                          );
                                        });
                                      },
                                      splashColor: Colors.red.shade50,
                                      splashRadius: 20.0,

                                      icon: const Icon(CupertinoIcons.cart, color: Colors.red) ,
                                      iconSize: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
                                  color: Colors.black54
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0),
                                          child: Container(
                                            // color: Colors.blue,
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context).size.width * .60
                                            ),
                                            child:                                         Text(
                                              widget.medicineArgs.name,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.white,
                                                fontSize: 22.0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'GHC${widget.medicineArgs.price}',
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
