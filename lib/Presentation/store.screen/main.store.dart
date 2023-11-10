import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/homepage.screen/widgets/more.products.dart';
import 'package:pharmacy/Presentation/store.screen/widgets/store.items.widget.dart';

class MainStorePage extends StatefulWidget {
  const MainStorePage({super.key});

  @override
  State<MainStorePage> createState() => _MainStorePageState();
}

class _MainStorePageState extends State<MainStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
          ),
          width: double.infinity,
          height: 40,
          child: const Center(
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Search for something',
                  prefixIcon: Icon(CupertinoIcons.search_circle, color: Color(0xFF13CA87))),
            ),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            StoreWidget()
          ],
        ),
      ),
    );
  }
}
