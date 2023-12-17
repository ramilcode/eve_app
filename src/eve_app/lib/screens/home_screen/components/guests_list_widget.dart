import 'package:eve_app/constants/app_sizes.dart';
import 'package:eve_app/screens/home_screen/components/guest_widget.dart';
import 'package:flutter/material.dart';

import 'package:eve_app/models/guest.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GuestsListWidget extends StatelessWidget {
  final List<Guest> guests;
  const GuestsListWidget({
    Key? key,
    required this.guests,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sWidth = size.width;
    return AnimationLimiter(
        child: ListView.builder(
            itemCount: guests.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == guests.length) {
                return Container(
                  height: 60,
                );
              }
              Guest guest = guests[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.symmetric(horizontal: AppSizes.calcScreenHorizontalPadding(sWidth)),
                      child: GestureDetector(
                        child: Column(children: [
                          GuestWidget(guest: guest),
                        ]),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              );
            }));
  }
}
