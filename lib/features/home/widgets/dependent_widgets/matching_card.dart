import 'package:flutter/material.dart';

class MatchingCardWidget extends StatelessWidget {
  const MatchingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Color(0xFF05204A)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              child: Text(
                'Người thân của bạn vừa tạo cho bạn một chuyến đi mới',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CircleAvatar(
              maxRadius: 120,
              backgroundColor: Colors.white,
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/091020ae03.jpg"),
                  scale: 6,
                )),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              child: Text(
                'Vui lòng đợi chúng tôi tìm tài xế thích hợp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
