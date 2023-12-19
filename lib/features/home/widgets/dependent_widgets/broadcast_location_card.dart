import 'package:flutter/material.dart';

class BroadCastLocationWidget extends StatelessWidget {
  const BroadCastLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            child: Text(
              'Định vị của bạn đang được gửi đến người thân ...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),
          CircleAvatar(
            maxRadius: 120,
            backgroundColor: Colors.white,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/icons/location.png"),
                scale: 1.5,
              )),
            ),
          ),
          // const SizedBox(height: 15),
          // LoadingAnimationWidget.prograssiveDots(color: Colors.white, size: 50),
          const SizedBox(height: 30),
          const SizedBox(
            child: Text(
              'Bạn sẽ nhận được thông tin chuyến đi ngay khi người thân của bạn đặt chuyến',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
