import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy/Constants/constants.dart';
import 'package:pharmacy/GlobalWidgets/SnackBar/snack-bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:http/http.dart' as http;

class MainCartItemsArgs {
  String image;
  String drug;
  String price;
  int quantity;
  MainCartItemsArgs({required this.image, required this.drug, required this.price, required this.quantity});
}

class MainOrdersPage extends StatefulWidget {
  const MainOrdersPage({super.key, required this.mainCartItemsArgs});
  final MainCartItemsArgs mainCartItemsArgs;
  @override
  State<MainOrdersPage> createState() => _MainOrdersPageState();
}

class _MainOrdersPageState extends State<MainOrdersPage> {
  late bool _btnCircularProgress, isImageEmpty;
  var picker = ImagePicker(); // The variable to pick the image from the gallery
  var imageFile;
  late File? image = null;
  var quantity;
  var originalPrice;
  var price;


  // Let's get the file and send it to the database...
  SupabaseClient supabase = SupabaseClient(
      'https://batmubdfrlbcaniaaxrr.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJhdG11YmRmcmxiY2FuaWFheHJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTcwMjAwMDAsImV4cCI6MjAxMjU5NjAwMH0.WGtc3fIqjnVnz1vq2M5_UXaj4fxeSe5-shYjgs9SMgk'
  );
  Future<void> selectFile() async {
    try {
      imageFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      image = File(imageFile.path);

      setState(() {
        if (imageFile != null) {
          image = File(imageFile.path);
        }
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  var url;
  Future<void> sendImage () async {
    if (image != null){
      setState(() {
        _btnCircularProgress = true;
      });
      isImageEmpty = false;
      final bytes = await imageFile.readAsBytes();
      final fileExtension = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExtension';
      final filePath = fileName;

      var response = await supabase
          .storage
          .from('images/pharmacy')
          .uploadBinary(
          filePath,
          bytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false)
      );

      if (response.isNotEmpty){
        final avatarURL = await supabase
            .storage
            .from('images/avatars')
            .getPublicUrl('$filePath');
        url = avatarURL;
        if(url.isNotEmpty){
          checkOut();
        }
      }
    } else {
      setState(() {
        _btnCircularProgress = false;
        isImageEmpty = true;
      });
    }
  }

  // The signup function
  Future<void> checkOut () async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cart = preferences.getStringList('cart');

    if (cart != null && cart.isNotEmpty) {
      var response;
      for (var item in cart) {
        var itemData = jsonDecode(item);

        var requestBody = {
          "productId": itemData['id'],
          "quantity": itemData['quantity'],
        };

        try {
          response = await http.post(
            Uri.parse(ORDER),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          );
        } catch (error) {
          print('Error during checkout: $error');
        } finally {
          print('THE IMAGE PRESCRIPTION: ${response.body}');
        }
      }

      if (response.statusCode == 201){
        var response1;
        var requestBody = {
          "image": url,
        };
        try{
          response1 = await http.post(Uri.parse(CHECKOUT),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(requestBody)
          );
        } catch (error){
          print('ERROR CONNECTING TO SERVER: $error');
        } finally {
          final Map<String, dynamic> jsonResponseBody = jsonDecode(response1.body);
          preferences.remove('cart');
          setState(() {
            getCart();
            _btnCircularProgress = false;
            MySnackBar().mySnackBar(context, 'Order placed successfully!', const Color(0xFF13CA87), CupertinoIcons.check_mark);
          });
        }
      } else {
        setState(() {
          setState(() {
            _btnCircularProgress = false;
          });
          MySnackBar().mySnackBar(context, 'Sorry, cannot checkout', CupertinoColors.destructiveRed, CupertinoIcons.info_circle);
        });
      }
    }
  }



// A LIST TO RETRIEVE THE CART ITEMS...
  List<Map<String, dynamic>> lisItems = [];
  double totalPrice = 0.0;
// FUNCTION TO CALCULATE TOTAL PRICE
  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (Map<String, dynamic> item in lisItems) {
      double itemPrice = item['price'] ?? 0.0;
      totalPrice += itemPrice;
    }
  }
  Future<void> getCart() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final cart = preferences.getStringList('cart');

    print('THESE ARE THE ITEMS IN THE CART: $cart');

    // LET'S DECLARE A LOCAL LIST VARIABLE TO AVOID LAYOUT CONFLICT
    List<Map<String, dynamic>> localLisItems = [];
    if (cart != null) {
      cart.forEach((item) {
        Map<String, dynamic> decodeItem = jsonDecode(item);
        localLisItems.add(decodeItem);

        String prices = decodeItem['price'] ?? '0.0';
        totalPrice += double.parse(prices);
      });
    }

    // ASSIGN THE LOCAL LIST VARIABLE TO THE GLOBAL ONE AFTER THE UPDATE
    setState(() {
      lisItems = localLisItems;
    });
  }
// FUNCTION TO REMOVE AND UPDATE TOTAL PRICE
  Future<void> removeFromCart(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // LET US RETRIEVE THE CURRENT
    List<String>? cart = preferences.getStringList('cart');
    if (cart != null) {
      cart.removeAt(index);
      preferences.setStringList('cart', cart);

      // LET'S UPDATE THE STATES AFTER THE DELETE
      getCart();
      calculateTotalPrice();
    }
  }



  @override
  void initState() {
    _btnCircularProgress = false;
    super.initState();
    isImageEmpty = false;
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color(0xFFFFFFFF),
          iconTheme: const IconThemeData(color: Color(0xFF13CA87)),
          title: const Text(
            'My Cart',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF13CA87)),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Column(
                      children: List.generate(lisItems.length, (index) {
                        setState(() {
                          originalPrice = double.parse(lisItems[index]['price']);
                          price = double.parse(lisItems[index]['price']);
                          price = int.parse(lisItems[index]['quantity']);
                        });

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
                                                child: Image(image: NetworkImage(lisItems[index]['image']), fit: BoxFit.cover,))),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lisItems[index]['name']??'',
                                                style: const TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                              Text(
                                                'Stock: ${lisItems[index]['stock']}'??'',
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
                                                    lisItems[index]['quantity']??'',
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
                                                  setState(() {
                                                    lisItems.removeAt(index);
                                                    removeFromCart(index);
                                                  });
                                                },
                                                child: const Icon(
                                                  CupertinoIcons.trash,
                                                  color: CupertinoColors.systemRed,
                                                )),
                                            Text(
                                              'Ghc${lisItems[index]['price']}'??'',
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
                      })),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: lisItems.isEmpty
                      ? const Text('')
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  'Ghc${totalPrice.toString()}',
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Taxes',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20.0,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  Text(
                                    'Free',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20.0,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  'Free',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20.0,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Ghc${totalPrice.toString()}',
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                // CONDITIONAL CHECK...
                image != null
                    ? MaterialButton(
                        onPressed: () {
                          selectFile();
                        },
                        color: CupertinoColors.systemRed,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const Text(
                          'change image',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Text(''),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: SizedBox(
                    child: DottedBorder(
                      color: const Color(0xFF13CA87),
                      strokeWidth: 1,
                      dashPattern: const [10, 6],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(
                                color: const Color(0xFF13CA87),
                                width: 3,
                              )),
                          width: MediaQuery.of(context).size.width,
                          height: 250.0,
                          child: Center(
                            child: lisItems.isEmpty
                                ? const Text(
                                    'No Medicine in Your Cart',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF13CA87),
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: image != null
                                        ? Image.file(
                                            File(image!.path),
                                            fit: BoxFit.cover,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1,
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              selectFile();
                                            },
                                            child: Text(
                                              'Upload prescription',
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: isImageEmpty? CupertinoColors.systemRed : const Color(0xFF13CA87),
                                              ),
                                            ),
                                          ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // CONDITIONAL CHECK...
                lisItems.isEmpty
                    ? const Text('')
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // onTap function goes here...
                                _btnCircularProgress = true;
                                sendImage();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * .9, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                backgroundColor: const Color(0xFF13CA87),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
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
                                        "Checkout",
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
                      ),
              ]),
              // CONDITIONAL CHECK....
            )));
  }
}
