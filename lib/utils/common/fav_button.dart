import 'package:flutter/material.dart';

class FavButton extends StatefulWidget {
  const FavButton({
    super.key,
  });

  @override
  State<FavButton> createState() => _FavButtonState();
}

class _FavButtonState extends State<FavButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showModalBottomSheet(
        //   context: context,
        //   backgroundColor: Colors.white,
        //   isScrollControlled: true,
        //   constraints: BoxConstraints.tightFor(
        //     height: MediaQuery.sizeOf(context).height * 0.6,
        //   ),
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        //   ),
        //   builder: (context) {
        //     return const AddToItineraySheet();
        //   },
        // );
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xffE2E2E2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: isFavorite
              ? Image.asset(
                  'assets/images/heart.png',
                  color: const Color(0xffCF5253),
                )
              : Image.asset(
                  'assets/images/un_heart.png',
                ),
        ),
      ),
    );
  }
}
