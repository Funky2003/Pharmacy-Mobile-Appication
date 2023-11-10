import 'package:flutter/material.dart';
import 'package:pharmacy/Presentation/drug-detail.screen/widgets/drug.preview.widget.dart';

class MainDrugDetailScreenArgs {
  String id;
  String image;
  String drug;
  String price;
  String stock;
  MainDrugDetailScreenArgs({required this.image, required this.drug, required this.price, required this.stock, required this.id});
}

class MainDrugDetailScreen extends StatefulWidget {
  const MainDrugDetailScreen({super.key, required this.mainDrugDetailScreenArgs});
  final MainDrugDetailScreenArgs mainDrugDetailScreenArgs;
  @override
  State<MainDrugDetailScreen> createState() => _MainDrugDetailScreenState();
}

class _MainDrugDetailScreenState extends State<MainDrugDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        title: const Text(
            'Drug Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrugImageDetailWidget(
                  detailArgs: DrugImageDetailArgs(
                  id: widget.mainDrugDetailScreenArgs.id,
                  image: widget.mainDrugDetailScreenArgs.image,
                  drug: widget.mainDrugDetailScreenArgs.drug,
                  price: widget.mainDrugDetailScreenArgs.price,
                  stock: widget.mainDrugDetailScreenArgs.stock,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
