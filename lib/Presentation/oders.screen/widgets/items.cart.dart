import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ItemsCartArgs {
  String image;
  String drug;
  String price;
  String quantity;
  String stock;
  List index = [];
  var itmIndex;
  ItemsCartArgs({ required this.itmIndex, required this.index, required this.image, required this.drug, required this.price, required this.quantity, required this.stock});
}

class ItemsCartWidget extends StatefulWidget {
  const ItemsCartWidget({super.key, required this.itemsCartArgs});
  final ItemsCartArgs itemsCartArgs;
  @override
  State<ItemsCartWidget> createState() => _ItemsCartWidgetState();
}

class _ItemsCartWidgetState extends State<ItemsCartWidget> {
  var quantity;
  var originalPrice;
  var price;

  @override
  void initState() {
    setState(() {
      originalPrice = double.parse(widget.itemsCartArgs.price);
      quantity = double.parse(widget.itemsCartArgs.quantity);
      price = double.parse(widget.itemsCartArgs.price);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: SizedBox(
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                  child: Image(image: NetworkImage(widget.itemsCartArgs.image), fit: BoxFit.cover,))),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.itemsCartArgs.drug,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),

                                 Text(
                                  'Stock Quantity: ${widget.itemsCartArgs.stock}',
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
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
                                    Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold
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
                              ],
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                  onTap: (){
                                    widget.itemsCartArgs.index.removeAt(4);
                                  },
                                  child: const Icon(
                                    CupertinoIcons.trash,
                                    color: CupertinoColors.systemRed,
                                  )),
                              Text(
                                'Ghc${price.toString()}',
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
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
