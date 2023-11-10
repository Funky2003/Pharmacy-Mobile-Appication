import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  Future<void> saveData({
    required String id,
    required String name,
    required String image,
    required String price,
    required String stock,
    required String quantity,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final Map<String, String> newItem = <String, String>{
      'id': id,
      'name': name,
      'image': image,
      'price': price.toString(),
      'stock': stock,
      'quantity': quantity.toString(),
    };

    List<String>? cart = preferences.getStringList("cart");
    cart ??= [];

    // CHECK IF AN ITEM ALREADY EXIST IN THE STORAGE
    int existingItemIndex = cart.indexWhere((item) {
      Map<String, dynamic> decodedItem = jsonDecode(item);
      return decodedItem['id'] == id;
    });

    if (existingItemIndex != -1) {
      // IF AN ITEM 'ID' ALREADY EXISTS IN THE STORAGE, UPDATE THE QUANTITY
      Map<String, dynamic> existingItem = jsonDecode(cart[existingItemIndex]);
      int newQuantity = int.parse(existingItem['quantity']) + int.parse(quantity);
      int newPrice = int.parse(existingItem['price']) + int.parse(price);
      existingItem['quantity'] = newQuantity.toString();
      existingItem['price'] = newPrice.toString();
      cart[existingItemIndex] = jsonEncode(existingItem);
    } else {
      // IF THERE IS NO ITEM WITH THE SAME 'ID' ADD IT TO THE STORAGE
      cart.add(jsonEncode(newItem));
    }

    // Update the cart in SharedPreferences
    preferences.setStringList('cart', cart);
  }

}