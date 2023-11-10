import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/oders.screen/widgets/oders.main.dart';
import '../../../SharedPreferences/shared-prefences.dart';

class DrugImageDetailArgs {
  String id;
  String image;
  String drug;
  String price;
  String stock;
  DrugImageDetailArgs({required this.image, required this.drug, required this.price, required this.stock, required this.id});
}

class DrugImageDetailWidget extends StatefulWidget {
  const DrugImageDetailWidget({super.key, required this.detailArgs});
  final DrugImageDetailArgs detailArgs;
  @override
  State<DrugImageDetailWidget> createState() => _DrugImageDetailWidgetState();
}

class _DrugImageDetailWidgetState extends State<DrugImageDetailWidget> {
  late bool _btnCircularProgress;
  var quantity = 1;
  var originalPrice;
  var price;

  @override
  void initState() {
    _btnCircularProgress = false;
    super.initState();
    setState(() {
      originalPrice = double.parse(widget.detailArgs.price);
      price = double.parse(widget.detailArgs.price);
    });
  }

  // SAVING THE DATA INTO THE SHARED PREFERENCES STORAGE...
  void saveData () {
    SharedPrefs().saveData(
        id: widget.detailArgs.id,
        name: widget.detailArgs.drug,
        image: widget.detailArgs.image,
        price: price.toString(),
        stock: widget.detailArgs.stock,
        quantity: quantity.toString(),
    );
  }

  @override
  void dispose() {
    _btnCircularProgress;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * .90,
                        child: Image(image: NetworkImage(widget.detailArgs.image), fit: BoxFit.cover))),
              ],
            ),

            SizedBox(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.detailArgs.drug,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            Text(
                              'Stock Quantity: ${widget.detailArgs.stock}',
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20.0,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity',
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: (){
                                  if(quantity > 1){
                                    setState(() {
                                      quantity--;
                                    });
                                    if(price > originalPrice){
                                      price -= originalPrice;
                                    }
                                  }
                                },
                                icon: const Icon(
                                  CupertinoIcons.minus_circle,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                               Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    quantity++;
                                    price += originalPrice;
                                  });
                                },
                                icon: const Icon(
                                    CupertinoIcons.plus_circle_fill,
                                    color: Color(0xFF13CA87)
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Ghc${price.toString()}',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0x1013CA87),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: IconButton(
                          onPressed: (){
                            saveData();
                          },
                          icon: const Icon(
                            CupertinoIcons.cart,
                            color: Color(0xFF13CA87)
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Add to cart',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // onTap function goes here...
                          saveData();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)
                              {
                                return MainOrdersPage(
                                  mainCartItemsArgs: MainCartItemsArgs(
                                      image: widget.detailArgs.image,
                                      drug: widget.detailArgs.drug,
                                      price: price.toString(),
                                      quantity: quantity
                                  ));
                              }
                          )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(MediaQuery.of(context).size.width*.55, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          backgroundColor: const Color(0xFF13CA87),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                            "Buy Now",
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}
