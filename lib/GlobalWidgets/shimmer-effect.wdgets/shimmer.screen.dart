import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffects {
  static final Color _shimmerColor = Colors.grey[200]!;
  static final Color _shimmerColorDark = Colors.grey[500]!;

  static homeShimmer({required BuildContext context}){
   return SingleChildScrollView(
     scrollDirection: Axis.horizontal,
     child: Row(
       children: List.generate(15, (index) {
         return Shimmer.fromColors(
           baseColor: _shimmerColor,
           highlightColor: _shimmerColorDark,
           child: Padding(
             padding: const EdgeInsets.all(12.0),
             child: Container(
               constraints: BoxConstraints(
                 minHeight: MediaQuery.of(context).size.height * .25,
                 maxWidth: MediaQuery.of(context).size.width * .50,
               ),
               decoration: const BoxDecoration(
                 borderRadius: BorderRadius.all(
                   Radius.circular(20.0),
                 ),
                 color: Colors.white,
               ),
             ),
           ),
         );
       }),
     ),
   );
  }
}