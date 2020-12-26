import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goaltracker/screens/auth/login.dart';
import 'package:goaltracker/style/style.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset('assets/images/bigGreen.svg'),
          ),
          Positioned(
            bottom: 200,
            left: 0,
            child: SvgPicture.asset('assets/images/smallGreen.svg'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [],
                ),
                Text('Welcome to Goal Tracker',
                    style: BigBoldHeading.copyWith(fontSize: 29)),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Largest Application of people competing with other\' goals ',
                  textAlign: TextAlign.center,
                  style: GreySubtitle.copyWith(fontSize: 16),
                ),
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset:
                              Offset(0, 0), // shadow direction: bottom right
                        )
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment
                            .centerRight, // 10% of the width, so there are ten blinds.
                        colors: [
                          kPrimaryColor,
                          const Color(0xff149959)
                        ], // red to yellow
                        tileMode: TileMode
                            .repeated, // repeats the gradient over the canvas
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text('GET STARTED', style: WhiteSansHeading),
                        Icon(
                          Icons.arrow_right_alt,
                          size: 30,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
