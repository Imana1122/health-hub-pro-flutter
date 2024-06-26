import '../common/color_extension.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';

class TodayMealRow extends StatelessWidget {
  final Map mObj;
  const TodayMealRow({super.key, required this.mObj});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                mObj["recipe"]['images'] != null &&
                        (mObj["recipe"]['images'] as List).isNotEmpty &&
                        mObj["recipe"]['images'][0]['image'] != null
                    ? 'http://10.0.2.2:8000/storage/uploads/recipes/small/${mObj["recipe"]['images'][0]['image']}'
                    : 'http://10.0.2.2:8000/admin-assets/img/default-150x150.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // This function is called when the image fails to load
                  // You can return a fallback image here
                  return Image.asset(
                    'assets/img/non.png', // Path to your placeholder image asset
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["recipe"]["title"].toString(),
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${getDayTitle(mObj["created_at"].toString())} | ${getStringDateToOtherFormate(mObj["created_at"].toString(), outFormatStr: "h:mm aa")}",
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/img/bell.png",
                width: 25,
                height: 25,
              ),
            )
          ],
        ));
  }
}
